require 'bundler/setup'
require 'parslet'

# Parse strings into a tree of terms
class Parser < Parslet::Parser
  rule(:space) { match('\s').repeat(1) }
  rule(:space?) { space.maybe }

  rule(:t_true) { str('true').as(:term) }
  rule(:t_false) { str('false').as(:term) }

  rule(:t_if) do
    (str('if') >> space >> term.as(:condition) >> space? >>
     str('then') >> space >> term.as(:then) >> space? >>
     str('else') >> space >> term.as(:else)).as(:if)
  end

  rule(:term) { space? >> (t_true | t_false | t_if) >> space? }
  root(:term)
end
