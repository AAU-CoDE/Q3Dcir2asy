
struct Node
    id::Int
    net::String
    name::String
end

Node(m::RegexMatch) = Node(parse(Int, m[:node_id]), m[:net], m[:node_name])

function cir2asy(fName)
    rNodes = r"^\* node (?P<node_id>\d+)+\s+(?P<net>.+):(?P<node_name>.+)"

    lines = readlines(fName)
    nodes = match.(rNodes, lines) |> filter(!isnothing) .|> Node

    nNodes = length(nodes)
    longestName = getfield.(nodes, :name) .|> length |> maximum

    nodeXY(id) = (x=-8longestName - 16, y=32 * (id - 1) - 16 * (nNodes - 1))

    window = (
        bottom=nodeXY(first(nodes).id).y - 16,
        top=nodeXY(last(nodes).id).y + 16,
        left=nodeXY(nodes[1].id).x,
        right=-nodeXY(nodes[1].id).x)

    rSubcktName = r"^\*\s*Topckt:\s*(?P<name>.+)"
    subcktName = match.(rSubcktName, lines) |> filter(!isnothing) |> first |> m -> m[:name]

    fNameSubckt = splitpath(fName) |> last
    fNameSymbol = replace(fName, r"cir$" => "asy")

    header = """
    Version 4
    SymbolType BLOCK
    RECTANGLE Normal $(window.left) $(window.bottom) $(window.right) $(window.top)
    WINDOW 0 0 $(window.bottom) Bottom 2
    WINDOW 3 0 $(window.top) Top 2
    SYMATTR Prefix X
    SYMATTR Value $subcktName
    SYMATTR ModelFile $fNameSubckt
    """

    open(fNameSymbol, "w") do f
        write(f, header)

        for n in nodes
            nx = string(nodeXY(n.id).x)
            ny = string(nodeXY(n.id).y)
            string(nodeXY(n.id).x)
            pinString = """
            PIN $nx $ny LEFT 8
            PINATTR PinName $(n.name)
            PINATTR SpiceOrder $(n.id)
            """
            write(f, pinString)
        end
    end
end
