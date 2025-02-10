extends Node


# ==================================================================
# Graph Node
# ==================================================================
func GraphNode_DisconnectAll(graph: GraphEdit):
	for i in graph.get_connection_list():
		graph.disconnect_node(i['from_node'],i['from_port'],i['to_node'],i['to_port'])

func GraphNode_DisconnectNode(graph: GraphEdit, node :GraphNode,output: bool, input: bool):
	for i in graph.get_connection_list():
		if output and i['from_node']==node.name:
			graph.disconnect_node(i['from_node'],i['from_port'],i['to_node'],i['to_port'])
		if input and i['to_node']==node.name:
			graph.disconnect_node(i['from_node'],i['from_port'],i['to_node'],i['to_port'])

# ==================================================================
# Graph Edit
# ==================================================================
func GraphEdit_GetCenter(Graph: GraphEdit)->Vector2:
	var middle_point = Vector2(
	Graph.scroll_offset.x + Graph.size.x / 2,
	Graph.scroll_offset.y + Graph.size.y / 2
	)
	var screen_middle = middle_point + Graph.global_position
	return screen_middle
