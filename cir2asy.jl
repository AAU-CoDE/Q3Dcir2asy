
rNodes = r"^\* node (?P<node_id>\d+)+\s+(?P<net>[\w]+):(?P<node_name>[\w]+)"

lines = readlines("test/parallel_conductors.cir")

struct Node
    node_id::Int
    net::String
    node_name::String
end

Node(m::RegexMatch) = Node(parse(Int, m[:node_id]), m[:net], m[:node_name])

nodes = map(ln -> match(rNodes, ln), lines) |> filter(!isnothing) .|> Node
