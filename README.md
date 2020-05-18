# JULIA_EKR_SIMPLEX_PROBLE_CALCULATOR


This is a julia language copy of a program that I made in python
To get the python version go to
 https://github.com/kimutaiRop/EKR-SIMPLEX-PROBLEM-CALCULATOR

 To run the program you just need to install julia go to
 https://julialang.org/download/
 download version v1.4 and above and install

 to run the program clone the program and move to the dir where you cloned the project to 
 run
    
`julia simplex.jl`

julia has no good way of displaying matrices as of now so you might need to do some few copy and pest of the output
of the output arrays

The project is still under developmment and is also free to expand, everyting is build using functions which breaks the code to smaller
easy to manage code

you can clone the project and expand or add new features and push to this repository then ask me to to marge 


![alt text](https://github.com/kimutaiRop/JULIA_EKR_SIMPLEX_PROBLE_CALCULATOR/blob/master/Annotation%202020-05-18%20090516.png)

the image show solution for the equation bellow

    #(x1 and x2 being products)
    
    #example equiz (mimimize for the equiz bellow)

    #4x1 + 2x2 >= 4
    #2x1 + 3x2 => 4
    #z = 3x1 + x2


#making array our of the equiz

you can change between silving maximization and minimization in the    `main() ` function by reading the comments there

this will soon be made easier by including user input, this is however good incase you want to use this as a module