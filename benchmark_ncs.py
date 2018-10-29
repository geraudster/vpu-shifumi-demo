from mvnc import mvncapi

device_list = mvncapi.enumerate_devices()
device = mvncapi.Device(device_list[0])
device.open()
GRAPH_FILEPATH = './target/ncs/ncs.graph'
with open(GRAPH_FILEPATH, mode='rb') as f:
    graph_buffer = f.read()

graph = mvncapi.Graph('graph1')
input_fifo, output_fifo = graph.allocate_with_fifos(device, graph_buffer)

import cv2
import numpy

import os
import time

tensors = [ cv2.imread(os.path.join(dirname, filename)).astype(numpy.float32) for dirname, dirnames, filenames in os.walk('data/alphashifumi/test') for filename in filenames ]
times = []
for tensor in tensors:
    start = time.time()
    graph.queue_inference_with_fifo_elem(input_fifo, output_fifo, tensor, 'test paper')
    output, user_obj = output_fifo.read_elem()
    times.append(time.time() - start)


tensor = cv2.imread('data/alphashifumi/test/paper/26475c05-9d1e-11e7-abeb-b1233b68540d-1.jpg')
tensor = tensor.astype(numpy.float32)
graph.queue_inference_with_fifo_elem(input_fifo, output_fifo, tensor, 'test paper')
output, user_obj = output_fifo.read_elem()
print(output)

input_fifo.destroy()
output_fifo.destroy()
graph.destroy()
device.close()
device.destroy()
