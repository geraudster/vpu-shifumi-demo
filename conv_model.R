library(reticulate)
use_virtualenv('~/.virtualenvs/r-tensorflow-py3', required = TRUE)
library(keras)
library(tensorflow)

source('freeze.R')
source('prepare_data.R')

k_clear_session()
k_set_learning_phase(1)

model <- keras_model_sequential()
model %>%
    layer_conv_2d(32, kernel_size = c(3,3), input_shape = c(128, 128, 1)) %>%
    layer_activation('relu') %>%
    layer_average_pooling_2d() %>%
    layer_conv_2d(32, kernel_size = c(3,3), input_shape = c(128, 128, 1)) %>%
    layer_activation('relu') %>%
    layer_average_pooling_2d() %>%
    layer_conv_2d(64, kernel_size = c(3,3), input_shape = c(128, 128, 1)) %>%
    layer_activation('relu') %>%
    layer_average_pooling_2d() %>%
    layer_flatten() %>%
    layer_dense(units = 1024, activation = 'relu') %>%
    layer_dense(units = 1024, activation = 'relu') %>%
    layer_dense(units = 5, activation = 'softmax', name = 'output')

summary(model)

model %>% compile(optimizer = 'rmsprop',
                  loss = 'categorical_crossentropy',
                  metrics = c('accuracy'))

generators <- get_generators('grayscale')
train_generator <- generators[[1]]
validation_generator <- generators[[2]]

history <- model %>% fit_generator(train_generator,
                                   validation_data = validation_generator,
                                   steps_per_epoch = nb_train_samples / batch_size,
                                   validation_steps = nb_validation_samples / batch_size,
                                   epochs = 5)

plot(history)

io_names <- freeze(model, model_output_file = 'conv_model')
io_names
