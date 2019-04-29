if (User.all().count == 0)
	u = User.new
	u.email = "admin@admin.com"
	u.password = "admin"
	u.role_id = 0
	u.save
end

if (Student.all().count == 0)
	s = Student.new
	s.fname = "Admin"
	s.lname = "Student"
	s.semester = "Spring 2019"
	s.phone_number = "1234567890"
	s.email = "admin@admin.com"
	s.user_id = 1 # current_user.id
	s.save
end

if (Employee.all().count == 0)
	e = Employee.new
	e.fname = "Admin"
	e.lname = "Employee"
	e.phone_number = "0123456789"
	e.email = "admin@admin.com"
	e.user_id = 1 # current_user.id
	e.save
end

if (Loan.all().count == 0)
	l = Loan.new
	l.check_out_date = "Today"
	l.check_in_date = "Tomorrow"
	l.expected_return_date = "Later later"
	l.student_id = 1
	l.book_id = 1 # current_user.id
	l.save
end

if (Donor.all().count == 0)
	d = Donor.new
	d.fname = "Admin"
	d.lname = "Donor"
	d.phone_number = "0123456789"
	d.email = "admin@admin.com"
	d.book_id = 1 # current_user.id
	d.save
end

if (Book.all().count == 0)
	b = Book.new
	b.title = "My First Book"
	b.edition = "First Edition"
	b.condition = "Terrible"
	b.author = "I Wrote This, First"
	b.cost = 99.99
	b.isbn = "0808080808080808080090"
	b.book_id = 1 # current_user.id
	b.save
end

if (Author.all().count == 0)
	a = Author.new
	a.fname = "Admin"
	a.lname = "Author"
	a.book_id = 1
	a.user_id = 1
	a.save
end

