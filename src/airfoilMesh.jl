using GLMakie, HOHQMesh
import .AirfoilTools as at

airfoil_data = at.read_airfoil("airfoil_folder/naca_2415.txt")
airfoil_data = vcat([1 0],airfoil_data) # add [1,0] no começo 
airfoil_data[end,:] = [1 0]
# adiciona nomeração a esquerda e z=0 na direita
airfoil_data = hcat(LinRange(0,1,size(airfoil_data)[1]), hcat(airfoil_data, zeros(size(airfoil_data)[1])))

#plot(airfoil_data[:,1], airfoil_data[:,2])
#xlims!(0, 1)
#ylims!(-0.5, 0.5)

box_project = newProject("box_two_circles", "out")

spline2 = newSplineCurve("airfoil", 62, airfoil_data)

addCurveToInnerBoundary!(box_project, spline2, "inner1")
bounds = [1.0, -1.0, -1.0, 2.0] #[top, left, bottom, right]
N = [20, 20, 0]
addBackgroundGrid!(box_project, bounds, N)

#generate_mesh(box_project)

plotProject!(box_project, MODEL+GRID)