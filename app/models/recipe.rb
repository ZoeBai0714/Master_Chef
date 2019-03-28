class Recipe < ApplicationRecord
    #has_and_belongs_to_many :cook_books
    has_many :cook_book_recipes
    has_many :cook_books, through: :cook_book_recipes
    has_many :recipe_ingredients
    has_many :ingredients, through: :recipe_ingredients

    validates :name, presence: true
    validates :cook_time, presence: true
    accepts_nested_attributes_for :ingredients
    

    def self.ingredients_with(name)
        Ingredient.find_by!(name:name).recipes
    end

    def self.ingredient_counts
        Ingredient.select('ingredients.*, count(recipe_ingredients.ingredient_id) as count').joins(:recipe_ingredients).group('recipe_ingredients.ingredient_id')
    end

    def ingredient_list
        ingredients.map(&:name).join(', ')
    end

    def ingredient_list=(names)
        self.igredients = names.split(',').map do |n|
            Ingredient.where(name: n.strip).first_or_create!
        end
    end

end
