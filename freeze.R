library(reticulate)
use_virtualenv('~/.virtualenvs/r-tensorflow-py3', required = TRUE)

library(keras)
library(tensorflow)

get_io_names <- function(model) {
    input <- strsplit(model$input$name, ':')[[1]][1]
    output <- strsplit(model$output$name, ':')[[1]][1]

    list(input = input, output = output)    
}

set_io_names_env <- function(input, output) {
    Sys.setenv(INPUT_NAME = input,
               OUTPUT_NAME = output)
}

freeze <- function(model, sess = k_get_session(), model_output_dir = './target/models/', type = 'pb') {
    ## re-build a model where the learning phase is now hard-coded to 0
    k_set_learning_phase(0)

#    model <- load_model_hdf5(saved_model_filename)

    config <- get_config(model)
    weights <- get_weights(model)

    new_model <- from_config(config)
    set_weights(new_model, weights)

    io_names <- get_io_names(new_model)

    optimized_graph <- sess$graph$as_graph_def()
    optimized_graph <- tf$graph_util$convert_variables_to_constants(sess, optimized_graph, list(io_names$output))


    tf$train$write_graph(optimized_graph, model_output_dir, paste('keras_to_tf', type, sep='.'), as_text=(type == 'txt'))
#    tf$train$write_graph(optimized_graph, model_output_dir, 'keras_to_tf.txt', as_text=TRUE)

    message(paste('Model written in', model_output_dir))
    io_names
}
