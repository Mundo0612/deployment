require 'data_mapper' # metagem, requires common plugins too.

# need install dm-sqlite-adapter
# if on heroku, use Postgres database
# if not use sqlite3 database I gave you
if ENV['DATABASE_URL']
  DataMapper::setup(:default, ENV['DATABASE_URL'] || 'postgres://localhost/mydb')
else
  DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/app.db")
end

# This will determine the admin and non admin
class User
    include DataMapper::Resource
    property :id, Serial
    property :email, Text
    property :password, Text
    property :created_at, DateTime
    property :role_id, Integer, default: 1

    def administrator?
        return role_id == 0
    end 

    def user?
        return role_id != 0
    end
    
    def login(password)
        return self.password == password
    end

    def as_json(*)
       super.except(:role_id)
    end

end

class Student
    include DataMapper::Resource
    property :id, Serial
    property :fname, Text
    property :lname, Text
    property :semester, Text
    property :phone_number, Text
    property :email, Text
    property :user_id, Integer
    property :created_at, DateTime

end

class Employee
    include DataMapper::Resource
    property :id, Serial
    property :fname, Text
    property :lname, Text
    property :phone_number, Text
    property :email, Text
    property :user_id, Integer
    property :created_at, DateTime
end

class Loan
    include DataMapper::Resource
    property :id, Serial
    property :check_out_date, Text
    property :check_in_date, Text
    property :expected_return_date, Text
    property :student_id, Integer # for Student Class
    property :book_id, Integer # for Book Class
    property :created_at, DateTime
end

class Donor
    include DataMapper::Resource
    property :id, Serial
    property :fname, Text
    property :lname, Text
    property :phone_number, Text
    property :email, Text 
    property :book_id, Integer
    property :created_at, DateTime
end

class Book
    include DataMapper::Resource
    property :id, Serial
    property :title, Text
    property :edition, Text
    property :condition, Text
    property :author, Text
    property :cost, Float
    property :isbn, Text  
    property :book_id, Integer
    property :created_at, DateTime
end

class Author
    include DataMapper::Resource
    property :id, Serial
    property :fname, Text
    property :lname, Text
    property :book_id, Integer # get from the book class
    property :user_id, Integer
    property :created_at, DateTime
end

# Perform basic sanity checks and initialize all relationships
# Call this when you've defined all your models
DataMapper.finalize

# automatically create the post table
User.auto_upgrade!
Student.auto_upgrade!
Employee.auto_upgrade!
Loan.auto_upgrade!
Donor.auto_upgrade!
Book.auto_upgrade!
Author.auto_upgrade!

DataMapper::Model.raise_on_save_failure = true  # globally across all models