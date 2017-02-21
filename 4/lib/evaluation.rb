require 'bundler/setup'
require 'parslet'

# Single step evaluation for the untyped language.
class Evaluation < Parslet::Transform
  # E-True
  rule(term: 'true') { 'true' }
  rule(term: 'false') { 'false' }

  # E-IfTrue
  rule(if: { condition: 'true', then: simple(:t2), else: simple(:t3) }) do
    t2
  end

  # E-IfFalse
  rule(if: {condition: 'false', then: simple(:t2), else: simple(:t3) }) do
    t3
  end

  # # E-If
  rule(if: {
         condition: simple(:t1),
         then: { term: simple(:t2) },
         else: { term: simple(:t3) }
       }) do
    cond = Evaluation.new.apply(t1)
    {
      if: {
        condition: { term: cond },
        then: { term: t2 },
        else: { term: t3 }
      }
    }
  end
end
