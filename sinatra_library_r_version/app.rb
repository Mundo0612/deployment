require "sinatra"
require 'sinatra/flash'
require_relative "authentication.rb"
require_relative "initializeDB.rb"

get "/" do
	erb :index
end

get "/dashboard" do
	authenticate!
	erb :dashboard
end

get "/administrator_management" do
	authenticate!
	erb :"management/administrator_management"
end

get "/book_management" do
	authenticate!
	erb :"management/book_management"
end

get "/student_management" do
	authenticate!
	erb :"management/student_management"
end

get "/users" do
	authenticate!
	my_hash = {}
	my_JSON = []
	us = User.all()
	us.each do |u|
		my_hash = {:id => u.id,
			:email => u.email,
			}
		my_JSON << JSON.generate(my_hash)
	end
	return my_JSON
end

get "/students" do
	authenticate!
	my_hash = {}
	my_JSON = []
	st = Student.all()
	st.each do |s|
		my_hash = {:id => s.id,
			:fname => s.fname,
			:lname => s.lname,
			:semester => s.semester,
			:phone_number => s.phone_number,
			:email => s.email,
			:user_id => s.user_id,
			}
		my_JSON << JSON.generate(my_hash)
	end
	return my_JSON
end

get "/students/push" do
	authenticate!
	erb :"create/create_student"
end

post "/students/create" do
	authenticate!
	s = Student.new
	s.fname = params["fname"]
	s.lname = params["lname"]
	s.semester = params["semester"]
	s.phone_number = params["phone_number"]
	s.email = params["email"]
	s.save
	s.user_id = s.id # current_user.id
	s.save

	my_hash = {:fname => s.fname,
			:lname => s.lname,
			:semester => s.semester,
			:phone_number => s.phone_number,
			:email => s.email,
			:user_id => s.user_id,
			}
	my_JSON = JSON.generate(my_hash)
	return my_JSON
end

get "/delete" do
	authenticate!
	erb :"management/delete_all"
	
end

#This is the delete request but used as a post
#TEST THIS LATER
post "/delete/action" do
	authenticate!
	category = params["category"]

	if category == "User" || category == "user"
		neutral = User.get(params["id"])
	elsif category == "Student" || category == "student"
		neutral = Student.get(params["id"])
	elsif category == "Employee" || category == "employee"
		neutral = Employee.get(params["id"])
	elsif category == "Loan" || category == "loan"
		neutral = Loan.get(params["id"])
	elsif category == "Donor" || category == "donor"
		neutral = Donor.get(params["id"])
	elsif category == "Book" || category == "book"
		neutral = Book.get(params["id"])
	elsif category == "Author" || category == "author"
		neutral = Author.get(params["id"])
	end

	if (neutral && current_user.role_id == 0)
		word = "Your ID of:#{neutral.id} was deleted"
		neutral.destroy
		return word
	else 
		halt 401, {message: "Not Admin or Invalid Category"}.to_json
	end
end

get "/employees" do
	authenticate!
	my_hash = {}
	my_JSON = []
	em = Employee.all()
		em.each do |e|
		my_hash = {:id => e.id,
			:fname => e.fname,
			:lname => e.lname,
			:phone_number => e.phone_number,
			:email => e.email,
			:user_id => e.user_id,
			}
			my_JSON << JSON.generate(my_hash)
	end
	return my_JSON # my_JSON.to_json also works
end

get "/employees/push" do
	authenticate!
	erb :"create/create_employee"
end

post "/employees/create" do
	authenticate!
	e = Employee.new
	e.fname = params["fname"]
	e.lname = params["lname"]
	e.phone_number = params["phone_number"]
	e.email = params["email"]
	e.save
	e.user_id = e.id # current_user.id
	e.save

	my_hash = {:fname => e.fname,
				:lname => e.lname,
				:phone_number => e.phone_number,
				:email => e.email,
				:user_id => e.user_id,
				}
	my_JSON = JSON.generate(my_hash)
	return my_JSON
end


get "/loans" do
	authenticate!
	my_hash = {}
	my_JSON = []
	lo = Loan.all()
	lo.each do |l|
		my_hash = {:id => l.id,
			:check_out_date => l.check_out_date,
			:check_in_date => l.check_in_date,
			:expected_return_date => l.expected_return_date,
			:student_id => l.student_id,
			:book_id => l.book_id,
			}
		my_JSON << JSON.generate(my_hash)
	end
	return my_JSON
end

get "/loans/push" do
	authenticate!
	erb :"create/create_loan"
end

post "/loans/create" do
	authenticate!
	l = Loan.new
	l.check_out_date = params["check_out_date"]
	l.check_in_date = params["check_in_date"]
	l.expected_return_date = params["expected_return_date"]
	l.student_id = params["student_id"]
	l.book_id = params["student_id"]
	l.save

	my_hash = {:check_out_date => l.check_out_date,
		:check_in_date => l.check_in_date,
		:expected_return_date => l.expected_return_date,
		:student_id => l.student_id,
		:book_id => l.book_id,
		}
	my_JSON = JSON.generate(my_hash)

	return my_JSON
end

get "/donors" do
	authenticate!
	my_hash = {}
	my_JSON = []
	don = Donor.all()
	don.each do |d|
		my_hash = {:id => d.id,
			:fname => d.fname,
			:lname => d.lname,
			:phone_number => d.phone_number,
			:email => d.email,
			:book_id => d.book_id,
			}
		my_JSON << JSON.generate(my_hash)
	end
	return my_JSON
end

get "/donors/push" do
	authenticate!
	erb :"create/create_donor"
end

post "/donors/create" do
	authenticate!
	d = Donor.new
	d.fname = params['fname']
	d.lname = params['lname']
	d.phone_number = params['phone_number']
	d.email = params['email']
	d.book_id = params['book_id']
	d.save

	my_hash = {:fname => d.fname,
		:lname => d.lname,
		:phone_number => d.phone_number,
		:email => d.email,
		:book_id => d.book_id,
		}
	my_JSON = JSON.generate(my_hash)

	return my_JSON
end

get "/books" do
	authenticate!
	my_hash = {}
	my_JSON = []
	bo = Book.all()
	bo.each do |b|
		my_hash = {:id => b.id,
			:title => b.title,
			:edition => b.edition,
			:condition => b.condition,
			:author => b.author,
			:cost => b.cost,
			:isbn => b.isbn,
			:book_id => b.book_id,
			}
		my_JSON << JSON.generate(my_hash)
	end
	return my_JSON
end

get "/books/push" do
	authenticate!
	erb :"create/create_book"
end

post "/books/create" do
	authenticate!
	b = Book.new
	b.title = params["title"]
	b.edition = params["edition"]
	b.condition = params["condition"]
	b.author = params["author"]
	b.cost = params["cost"]
	b.isbn = params["isbn"]
	b.save
	b.book_id = b.id 
	b.save

	my_hash = {:title => b.title,
		:edition => b.edition,
		:condition => b.condition,
		:author => b.author,
		:cost => b.cost,
		:isbn => b.isbn,
		:book_id => b.book_id,
		}
	my_JSON = JSON.generate(my_hash)
	return my_JSON
end

get "/authors" do
	authenticate!
	my_hash = {}
	my_JSON = []
	au = Author.all()
	au.each do |a|
		my_hash = {:id => a.id,
			:fname => a.fname,
			:lname => a.lname,
			:book_id => a.book_id,
			:user_id => a.user_id,
		}
	my_JSON << JSON.generate(my_hash)
	end
	return my_JSON
end


get "/authors/push" do
	authenticate!
	erb :"create/create_author"
end

post "/authors/create" do
	authenticate!
	a = Author.new
	a.fname = params["fname"]
	a.lname = params["lname"]
	a.book_id = params["book_id"]
	a.user_id = params["user_id"]
	a.save

	my_hash = {:fname => a.fname,
				:lname => a.lname,
				:book_id => a.book_id,
				:user_id => a.user_id,
				}
	my_JSON = JSON.generate(my_hash)

	return my_JSON
end
