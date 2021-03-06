# Finetune VGG16 Cats vs Dogs

library(keras)
library(dplyr)

# Preprocessing function --------------------------------------------------

preprocess_input <- function(x){
  
  x <- x[, , 3:1] #RGB -> BGR
  x[, , 1] <- x[, , 1] - 103.939
  x[, , 2] <- x[, , 2] - 116.779
  x[, , 3] <- x[, , 3] - 123.68
  return(x)
}

# Load VGG 16 ----------------------------------------------------------------
base_model <- application_vgg16(weights = 'imagenet', include_top = FALSE, 
                                input_shape = c(150, 150, 3))
summary(base_model)

# Top model
input_dim <- base_model$output %>% dim %>% unlist 
top_model <- keras_model_sequential() %>% 
  layer_flatten(input_shape = input_dim) %>% 
  layer_dense(units = 512, activation = "relu") %>% 
  layer_dense(units = 2, activation = "softmax")

model <- keras_model(input = base_model$input,
                     outputs = top_model(base_model$output))
  
freeze_weights(model, to = "block5_pool")
summary(model)
# Images generator ----------------------------------------------------------
batch_size <- 32

img_gen <- image_data_generator(preprocessing_function = preprocess_input)

train_gen <- flow_images_from_directory(directory = 'data/alphashifumi/train/',
                                        generator = img_gen,
                                        target_size = c(150, 150),
                                        batch_size = batch_size,
                                        class_mode =  "categorical")

val_gen <- flow_images_from_directory(directory = 'data/alphashifumi/test/',
                                      generator = img_gen,
                                      target_size = c(150, 150),
                                      batch_size = batch_size,
                                      class_mode =  "categorical")

model %>% compile(
  optimizer = "rmsprop",
  loss = "binary_crossentropy",
  metrics = "accuracy"
)

history <- model %>% fit_generator(
  train_gen, 
  steps_per_epoch = train_gen$n/batch_size,
  epochs = 10, 
  validation_data = val_gen
)
