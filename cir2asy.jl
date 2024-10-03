
struct Node
    id::Int
    net::String
    name::String
end
Node(m::RegexMatch) = Node(parse(Int, m[:node_id]), m[:net], m[:node_name])

rNodes = r"^\* node (?P<node_id>\d+)+\s+(?P<net>[\w]+):(?P<node_name>[\w]+)"

fName = "test/parallel_conductors.cir"
lines = readlines(fName)
nodes = match.(rNodes, lines) |> filter(!isnothing) .|> Node

nNodes = length(nodes)
nodeXY(id) = (x = -32, y = 32*(id-1) - 16*(nNodes-1))

window = (bottom = nodeXY(first(nodes).id).y - 8, top = nodeXY(last(nodes).id).y + 8)
