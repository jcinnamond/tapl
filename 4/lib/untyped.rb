require 'bundler/setup'
require 'parslet'

# Parse strings into a tree of terms
class UntypedParser < Parslet::Parser
  rule(:space) { match('\s').repeat(1) }
  rule(:space?) { space.maybe }

  rule(:t_true) { str('true').as(:true) }
  rule(:t_false) { str('false').as(:false) }
  rule(:t_if) do
    (str('if') >> space >> term.as(:condition) >> space? >>
     str('then') >> space >> term.as(:then) >> space? >>
     str('else') >> space >> term.as(:else)).as(:if)
  end

  rule(:term) { (t_true | t_false | t_if) >> space? }
  rule(:terms) { space? >> term.repeat(1) }
  root(:terms)
end
