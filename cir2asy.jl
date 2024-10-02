
struct Node
    node_id::Int
    net::String
    node_name::String
end
Node(m::RegexMatch) = Node(parse(Int, m[:node_id]), m[:net], m[:node_name])

rNodes = r"^\* node (?P<node_id>\d+)+\s+(?P<net>[\w]+):(?P<node_name>[\w]+)"

lines = readlines("test/parallel_conductors.cir")
nodes = match.(rNodes, lines) |> filter(!isnothing) .|> Node

nNodes = length(nodes)
nodeXY(id) = -32, 32id - 16*(nNodes-1)
