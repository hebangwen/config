import sys
import onnx

model = onnx.load(sys.argv[1])
output =[node.name for node in model.graph.output]

input_shape = [[m.dim_value for m in node.type.tensor_type.shape.dim] for node in model.graph.input]
output_shape = [[m.dim_value for m in node.type.tensor_type.shape.dim] for node in model.graph.output]

input_all = [node.name for node in model.graph.input]
input_initializer =  [node.name for node in model.graph.initializer]
net_feed_input = list(set(input_all)  - set(input_initializer))

print('Inputs: ', net_feed_input)
print('Input shapes: ', input_shape)
print('Outputs: ', output)
print('Output shapes: ', output_shape)

