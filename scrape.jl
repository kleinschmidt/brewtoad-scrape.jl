using Gumbo, HTTP, AbstractTrees

userid = if length(ARGS) ≥ 1
    ARGS[1]
else
    @warn "No userid supplied; you're getting Dave's recipes"
    "15935"
end

const baseurl = "https://www.brewtoad.com"

function recipe_links(userid)
    recipelinks = String[]
    pages = [baseurl * "/users/" * string(userid) * "/recipes"]
    while !isempty(pages)
        page = parsehtml(String(HTTP.request("GET", pop!(pages)).body))
        for node in PreOrderDFS(page.root)
            node isa HTMLElement{:a} || continue
            class = get(attrs(node), "class", "")
            if class == "recipe-link"
                link = attrs(node)["href"]
                push!(recipelinks, link)
                println(link)
            elseif class == "next_page"
                push!(pages, baseurl * attrs(node)["href"])
                println("Next page: ", attrs(node)["href"])
            end
        end
    end
    return recipelinks
end

function process_recipe(recipe_link)
    recipe_html = String(HTTP.request("GET", baseurl * recipe_link).body)
    recipe = parsehtml(recipe_html)
    recipe_str = match(r"/recipes/(.*)", recipe_link).captures[1]
    recipe_dir = "recipes/$recipe_str"
    mkpath(recipe_dir)

    title = strip(first(Iterators.filter(n -> n isa HTMLText && n.parent isa HTMLElement{:h1},
                                         PreOrderDFS(recipe.root))).text)

    println("processing recipe \"$title\" → $recipe_dir")

    open(joinpath(recipe_dir, "$recipe_str.html"), "w") do f
        println("  writing HTML for $title to $(f.name)...")
        write(f, recipe_html)
    end
    
    open(joinpath(recipe_dir, "$recipe_str.xml"), "w") do f
        println("  writing XML for $title to $(f.name)...")
        write(f, HTTP.request("GET", baseurl * recipe_link * ".xml").body)
    end
    
end


function main(userid)

    recipes = recipe_links(userid)
    
    # don't bother waiting on the HTTP requests :)
    @sync begin
        for recipe in recipes
            @async process_recipe(recipe)
        end
    end

end

main(userid)
