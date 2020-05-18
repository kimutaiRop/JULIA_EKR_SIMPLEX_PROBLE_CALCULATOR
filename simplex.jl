using LinearAlgebra

function main()
    #(x1 and x2 being products)
    #example equiz (maximize for the equiz bellow)
    #4x1 + 2x2 <= 4
    #2x1 + 3x2 <= 4

    #z = 3x1 + x2

    #making array our of the equiz

    i_type = 2 # change this to either one or two depending on problem (1=>maximization, 2=> minimization)
    # inputing data
    arr = [
        4 2; 
        2 3; 
        ] # change this to your values for the equation
    
    #making solution column out of the equiz
    solution = [4,4]

    #making the z row out of the equiz
    z_row = [3,1]
    if i_type == 1
        solution = vcat(solution, [0])
        final = format_max(arr, z_row)
        final[:,end] = solution
        maximization(final)
    else
        solution = vcat(solution, [0, 0 - sum(solution)])

        final = format_min(arr, z_row)
        final = hcat(final, vcat(solution...))
        minimization(final)
    end
end

function format_max(arr, last_row)
    n_rows, n_cols = size(arr)
    eye_mat = Matrix{Float64}(I, n_rows, n_rows + 1)
    extra_last = [0 for n = 1:n_rows + 1]
    last_row = 0 .- last_row
    last_row = vcat(last_row, extra_last)
    arr = hcat(arr, eye_mat)
    final = vcat(arr, transpose(last_row))
    return final

end

function format_min(arr, last_row)
    n_cols, n_rows = size(arr)
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
    return final
end

function check_neg(x)
    x < 0 ? 0 : x
end
     
function maximization(arr)
    final_t = solve(arr, 1)
    println(final_t)
end

function minimization(arr)
    final_t = solve(arr, 2)
    println(final_t)
end

function solve(arr, place)
    last_row = arr[end,:][1:end - 1]
    min_element_last_row, pivot_col_index = findmin(last_row)
    while min_element_last_row < 0
        pivot_column = arr[:,pivot_col_index]
        last_column = arr[:,end]
        # no reason to try/catch since julia has infinity for 0 divison error
        pivot_row_index  = findmin(check_neg.(pivot_column[1:end - place]) .\ abs.(last_column[1:end - place]))[2] # element wise division 
        pivot_row = arr[pivot_row_index,:]
        pivot_element = pivot_column[pivot_row_index]
        println(arr)
        println("""
                        
        pivot element :  $pivot_element |> row :  $pivot_row_index |> column :  $pivot_col_index
        pivot row     :  $pivot_row
        pivot column  :  $pivot_column
    
        """)
        forms_arr = [1 for n = 1:size(pivot_column[1:end])[1]]
        new_arr = [[0.0] for n = 1:size(pivot_column[1:end])[1]]
        for r in 1:size(forms_arr)[1]
            row = arr[r,:]
            elm = row[pivot_col_index]
            if r === pivot_row_index
                form = 1 / pivot_element
                final_val =  row .* form
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

        if place ===2
            arr,d_columns,d_rows = solve_array_min(arr,[],[],pivot_row_index,pivot_col_index)
        elseif place ===1
            arr,d_columns,d_rows = solve_array_max(arr,[],[],pivot_row_index,pivot_col_index)
        end

        last_row = arr[end,:][1:end - 1]
        min_element_last_row, pivot_col_index = findmin(last_row)
    end

    return arr
end

function solve_array_max(arr,d_columns,d_rows,pivot_row_index,pivot_col_index)
    # alter the array column and row names following the tablus method for maximization
    return (arr,d_columns,d_rows)
end

function solve_array_min(arr,d_columns,d_rows,pivot_row_index,pivot_col_index)
    # alter the array column and row names following the tablus method for minimization
    return (arr,d_columns,d_rows)
end
main()

