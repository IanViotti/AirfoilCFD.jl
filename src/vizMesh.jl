using GLMakie, HOHQMesh

function getMeshFromMeshFile(meshFile::AbstractString, meshFileFormat::AbstractString)
    open(meshFile,"r") do f
        line   = strip(readline(f)) # Header Should be ISM-V2
        line   = readline(f) # Numbers of nodes, edges ...
        values = split(line)

        nNodes = parse(Int64, values[1])
        nEdges = parse(Int64, values[2])
#
#          Read the nodes
#
        nodes = zeros(Float64, nNodes, 2)
        for i = 1:nNodes
            values = split(readline(f))
            for j = 1:2
                nodes[i,j] = parse(Float64, values[j])
            end
        end
#
#          Read the edges and construct the lines array
#
        xMesh = zeros(Float64, 3*nEdges)
        yMesh = zeros(Float64, 3*nEdges)

        for i = 1:3:3*nEdges

            values = split(readline(f))
            n      = parse(Int64,values[1])
            m      = parse(Int64,values[2])

            xMesh[i]   = nodes[n,1]
            xMesh[i+1] = nodes[m,1]
            xMesh[i+2] = NaN

            yMesh[i]   = nodes[n,2]
            yMesh[i+1] = nodes[m,2]
            yMesh[i+2] = NaN

        end
        return xMesh, yMesh
    end
end

xMesh, yMesh = getMeshFromMeshFile("meshOut/airfoilMesh.mesh", "ISM-V2")

plot(xMesh, yMesh)