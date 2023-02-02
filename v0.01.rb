#! /usr/bin/env ruby

require 'pg'
require 'date'

@expense_db = PG.connect(dbname:'project1')

# @expenses = @expense_db.exec('SELECT * FROM expenses ORDER BY id')

@command = ARGV[0]


def display_list
  @expenses = @expense_db.exec("SELECT * FROM expenses ORDER BY id")
  @expenses.each do |tuple|
    columns = [ tuple["id"].rjust(3),
                tuple["created_on"].rjust(10),
                tuple["amount"].rjust(12),
                tuple["memo"] ]
  
    puts columns.join(" | ")
  end
end



def display_help
  puts "An expense recording system\n\n"
  puts HELP
end

def validate_add(cost:, item:, date:)
  return 'Please enter a valid amount' unless cost.to_f > 0.0
  
  case 
    when !cost
      "You must specify an AMOUNT\n\n"
    when !item
      "You must specify a MEMO\n\n"
    when date
      begin
        Date.valid_date?(*date.to_s.split('-').map(&:to_i))
      rescue ArgumentError, NameError
        return "The date you have entered is invalid." 
      else
        false
      end
    else
      false
  end
end

def add_expense(cost: ARGV[1], item:ARGV[2], date:ARGV[3])
  error_help = validate_add(cost: cost, item: item, date: date)
  
  if !error_help
    @expense_db.exec_params("INSERT INTO expenses(amount, memo, created_on)"\
      "VALUES ($1, $2, $3);", [cost, item, (date ? date : Date.today.to_s)]).values
  else
    puts error_help
    puts @help
  end
end

if !@command || @command.downcase == 'help'
  display_help
elsif @command.downcase == 'list'
  display_list
elsif @command.downcase == 'add'
  add_expense
else
  puts "Sorry, #{@command} is not valid"
end