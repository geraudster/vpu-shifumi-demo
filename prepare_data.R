datagen_seed <- 123456

datagen <- image_data_generator(
    ##    rescale = 1./255,
    horizontal_flip = TRUE,
    fill_mode = "nearest",
    zoom_range = 0.3,
    width_shift_range = 0.3,
    height_shift_range = 0.3,
    rotation_range = 30,
    data_format = 'channels_last')

get_generators <- function(color_mode) {
    train_generator <- flow_images_from_directory(
        train_data_dir,
        generator = datagen,
        target_size = c(img_height, img_width),
        batch_size = batch_size, 
        class_mode = 'categorical',
        save_to_dir = augmented_data,
        color_mode = color_mode,
        seed = datagen_seed)

    validation_generator <- flow_images_from_directory(
        validation_data_dir,
        generator = datagen,
        target_size = c(img_height, img_width),
        batch_size = batch_size, 
        class_mode = 'categorical',
        color_mode = color_mode,
        seed = datagen_seed)

    list(train_generator, validation_generator) 
}
