using LinearAlgebra

function read_data()
    arr = []
    print("""

    This is console input format of the data

    """)
    print("how many product do you have : ")
    n_prods = readline()
    n_prods = parse(Int,n_prods)
    print("\nhow many constrains do you have : ")
    n_const = readline()
    n_const = parse(Int,n_const)
    print("Would you like to give the constrain names?(Y/N) :")
    ent_const = readline()
    const_names = [string("const_",x) for x = 1:n_const]
    sol_col = [x/1 for x = 1:n_const]
    z_row = [x/1 for x = 1:n_prods]
    if uppercase(ent_const) == "Y"
        for i in 1:n_const
            print("enter constrain $i name :")
            nm = readline()
            const_names[i] = nm
        end
    end
    t = 0
    for n in const_names
        rw = [x/1 for x=1:n_prods]
        for x in 1:n_prods
            print("enter the value of x$x in $n : ")
            val = readline()
            rw[x] =parse(Float32,val)
        end
        rw = hcat(rw...)
        if t == 0
            arr = rw
        else
            arr = vcat(arr,rw)
        end
        t+=1
        print("equate $n to : ")
        sol_val = readline()
        sol_val = parse(Float32, sol_val)
        sol_col[t] = sol_val
        print("\n")
    end
    for x in 1:n_prods
        print("enter the value of x$x in Z equation : ")
        val = readline()
        z_row[x] =parse(Float32,val)
    end
    return (z_row,arr,sol_col)
end
function help_call()
    print("""
    --HELP:
    USING SIMPLEX CALCULATOR

    ----- requirements -----

    1 -> julia - install julia (https://julialang.org)

    ----- choices -----

    1 -> Simplex maximization problems like maximization of profits
    2 -> Simplex minimization problem like minimization of expenditure in company

    0 -> Help on using the calculator

    ----- best data -----

    please rename your products to X₁, X₂, X₃...Xₙ
    for easy feeding of data

    n - being the number of products you have

    example: computers - X₁
             printers  - X₂

    you can use: - whole numbers
                 - decimal numbers
            Entering the value you are prompted to. the decimal are not
            rounded off on entering. this ensures high accuracy

    you are advised to use values less than 1 million
    you can standardize the data by dividing it to small values
    and re-converting after getting solution


    ----- assumptions -----

    I assume that you know how to read the simplex table.
    I also assume that you know how to interpret the data in the table and So
    I did not interpret the data

    This program is to be used by statisticians and also those with
    an idea on the simplex algorithmn

    This programs though need no much knowledge on mathematics/statistics

    ----- mixed simplex problem -----

    I have not made a choice for mixed simplex problem and so for now
    the program may not provide a solution for such problems

    ----- declaimer -----

    This program does not print the tables the way the python program does,
    you can copy a tableu array returned and pest in the julia interactive terminal
    (see the image linked to this repository)
    and the tables will be more clear (I did not want to use any library just to show the tables)

    Only the console  option of this program is available yet but the GUI might be available
    at some point and when available, I will update on how to use the GUI.

    The program has been tested with several examples but maybe all the exception
    may not have been countered fully. using this program will be an alternative
    you chose and so we I am not expecting a complain in failure to meet your expectation as indicated in the LICENCE.

    you are however free to add on the program but just incase you cannot,
    #You can suggest additions or even send me bugs in the program in the email below.#

    kimrop20@gmail.com

    ----- licence -----

    This program is to be used freely. You can also re-edit or modify or even add to
    this program.
    you can also share but you should not change the developer ownership.

    😄 I will appreciate credit given to me

    ----- developer -----

    developed by [ELPHAS KIMUTAI ROP] .
    Student Bsc. Statistics and programming.
    Machakos University, Kenya.
    Email   : kimrop20@gmail.com
    Website : http://bestcoders.herokuapp.com



    """)
end

function main()

    printstyled("""
        problem types:

            1 : maximization
            2 : minimization

            0: help

    """,color=:light_blue, bold=true)
    print("What problem type would you like to solve : ")
    i_type = readline()
    i_type = parse(Int,i_type)
    if i_type == 1
        z_row, arr,solution = read_data()
        solution = vcat(solution, [0])
        final, col_names, row_names = format_max(arr, z_row) #call data formatter
        final[:, end] = solution #add the solution columns
        maximization(final, col_names, row_names)
    elseif i_type==2
        z_row, arr,solution = read_data()
        solution = vcat(solution, [0, 0 - sum(solution)]) #add the siolution row
        final, col_names, row_names, del_cols = format_min(arr, z_row) #call data formatter
        final = hcat(final, vcat(solution...))
        minimization(final, col_names, row_names, del_cols)
    elseif i_type == 0
        help_call()
    else
        println("please run the program againa dn select the correct choice")
    end
end

function format_max(arr, last_row)
    #create column names
    col_names = [string("x", i) for i = 1:size(arr)[2]]

    # format the data array
    n_rows, n_cols = size(arr)
    eye_mat = Matrix{Float64}(I, n_rows, n_rows + 1)
    extra_last = [0 for n = 1:n_rows+1]
    last_row = 0 .- last_row
    last_row = vcat(last_row, extra_last)
    arr = hcat(arr, eye_mat)
    final = vcat(arr, transpose(last_row))

    #extend column names
    size_cols = size(col_names)[1]
    extra_cols = [string("x", size_cols + n) for n = 1:n_rows+1]
    col_names = vcat(col_names, extra_cols)
    col_names[end] = "sol"

    #create row names
    extra_cols[end] = "Z"
    row_names = extra_cols

    #return the table,col names and row names
    return (final, col_names, row_names)

end

function format_min(arr, last_row)
    col_names = [string("x", i) for i = 1:size(arr)[2]]
    n_rows,n_cols = size(arr)
    sub_last_r = 0 .- sum(arr, dims = 1)
    last_row = last_row
    eye_mat = Matrix{Float64}(I, n_rows, n_rows)
    eye_mat_neg = Matrix{Float64}(-I, n_rows, n_rows)
    extra_last_1s = [1 for n = 1:n_rows]
    extra_last = [0 for n = 1:n_rows]
    last_row = vcat(last_row, extra_last)
    last_row = vcat(last_row, extra_last) # has double the num cols
    sub_last_r = hcat(sub_last_r, hcat(extra_last_1s...)) # add ones cols
    sub_last_r = hcat(sub_last_r, hcat(extra_last...))
    last_row = vcat(hcat(last_row...), sub_last_r)
    arr = hcat(arr, eye_mat_neg)
    arr = hcat(arr, eye_mat)
    final = vcat(arr, last_row)
    size_cols = size(col_names)[1]
    extra_cols = [string("x", size_cols + n) for n = 1:n_rows]
    col_names = vcat(col_names, extra_cols)

    size_cols = size(col_names)[1]
    del_cols = [string("x", size_cols + n) for n = 1:n_rows]
    col_names = vcat(col_names, del_cols)
    row_names = vcat(del_cols, ["z", "z1"])

    col_names = vcat(col_names, ["sol"])
    return (final, col_names, row_names, del_cols)
end

check_neg(x) = x < 0 ? 0 : x

function maximization(arr, col_names, row_names)
    final_t, col_names, row_names = solve(arr, 1, col_names, row_names)
    println("""
        columns:      :  $col_names
        rows          :  $row_names
        final tableu  :  $final_t

        """)
end

function minimization(arr, col_names, row_names, del_cols)
    final_t, col_names, row_names =
        solve(arr, 2, col_names, row_names, del_cols)
    println("""
        columns:      :  $col_names
        rows          :  $row_names
        final tableu  :  $final_t

        """)
end

function solve(arr, place, col_names, row_names, arg...)
    last_row = arr[end, :][1:end-1]
    min_element_last_row, pivot_col_index = findmin(last_row)
    while min_element_last_row < 0
        pivot_column = arr[:, pivot_col_index]
        last_column = arr[:, end]
        # no reason to try/catch since julia has infinity for 0 divison error
        pivot_row_index = findmin(
            check_neg.(pivot_column[1:end-place]) .\ abs.(last_column[1:end-place]),
        )[2] # element wise division
        pivot_row = arr[pivot_row_index, :]
        pivot_element = pivot_column[pivot_row_index]

        println("""
        columns:      :  $col_names
        row           :  $row_names
        tableu        :  $arr

        pivot element :  $pivot_element |> row :  $pivot_row_index |> column :  $pivot_col_index
        pivot row     :  $pivot_row
        pivot column  :  $pivot_column

        """)
        forms_arr = [1 for n = 1:size(pivot_column[1:end])[1]]
        new_arr = [[0.0] for n = 1:size(pivot_column[1:end])[1]]
        for r = 1:size(forms_arr)[1]
            row = arr[r, :]
            elm = row[pivot_col_index]
            if r === pivot_row_index
                form = 1 / pivot_element
                final_val = row .* form
            elseif r === size(forms_arr)[1]
                form = abs(elm) / pivot_element
                final_val = form .* pivot_row
                final_val = final_val .+ row
            else
                form = (elm / pivot_element) .* pivot_row
                final_val = row .- form
            end
            new_arr[r] = final_val
        end
        new_arr = transpose(hcat(new_arr...))
        arr = new_arr

        if place === 2
            arr, d_columns, d_rows = solve_array_min(arr,col_names,row_names,pivot_row_index,pivot_col_index,arg[1])
        elseif place === 1
            arr, d_columns, d_rows = solve_array_max(arr,col_names,row_names,pivot_row_index,pivot_col_index)
        end
        row_names = d_rows
        col_names = d_columns
        last_row = arr[end, :][1:end-1]
        min_element_last_row, pivot_col_index = findmin(last_row)
    end

    return arr, col_names, row_names
end

function solve_array_max(arr,d_columns,d_rows,pivot_row_index,pivot_col_index)
    # alter the array column and row names following the tablus method for maximization
    d_rows[pivot_row_index] = d_columns[pivot_col_index]
    return (arr, d_columns, d_rows)
end

function solve_array_min(arr,d_columns,d_rows,pivot_row_index,pivot_col_index,del_col)
    pivot_col_name = d_columns[pivot_col_index]
    pivot_row_name = d_rows[pivot_row_index]

    in_del = pivot_row_name in del_col
    if in_del
        drop_el_index = findall(x -> x == pivot_row_name, d_columns)[1]

        d_columns = d_columns[1:end.!=drop_el_index]
        arr = arr[1:end, 1:end.!=drop_el_index]
    end
    d_rows[pivot_row_index] = pivot_col_name
    # alter the array column and row names following the tablus method for minimization
    return (arr, d_columns, d_rows)
end

main()

print("exit the program now (y/Y) :")
ext = readline()