require 'spec_helper'
require 'evaluation'

RSpec.describe Evaluation do
  subject { described_class.new.apply(tree) }

  let(:t_true) { { term: 'true' } }
  let(:t_false) { { term: 'false' } }

  describe 'E-True' do
    let(:tree) { t_true }
    it { is_expected.to eq('true') }
  end

  describe 'E-False' do
    let(:tree) { t_false }
    it { is_expected.to eq('false') }
  end

  describe 'E-IfTrue' do
    let(:tree) do
      {
        if: {
          condition: t_true,
          then: t_true,
          else: t_false
        }
      }
    end
    it { is_expected.to eq('true') }
  end

  describe 'E-IfFalse' do
    let(:tree) do
      {
        if: {
          condition: t_false,
          then: t_true,
          else: t_false
        }
      }
    end
    it { is_expected.to eq('false') }
  end

  describe 'E-If' do
    # Nested tree evaluates to true
    let(:nested_tree) { { if: { condition: t_true, then: t_true, else: t_false } } }
    # Tree evauluates to true, as nested_tree is true
    let(:tree) { { if: { condition: nested_tree, then: t_true, else: t_false } } }

    it { is_expected.to eq('true') }
  end

  describe 'nested condition' do
    # The innermost tree evaulautes to true
    let(:inner_tree) { { if: { condition: t_true, then: t_true, else: t_false } } }
    # The mid tree evaluates to false, as the inner tree is true
    let(:mid_tree) { { if: { condition: inner_tree, then: t_false, else: t_true } } }
    # The outer tree evaluates to false, as the mid tree is false
    let(:tree) { { if: { condition: mid_tree, then: t_true, else: t_false } } }

    it { is_expected.to eq('false') }
  end

  describe 'nested then' do
    # Tree for `then` evaluates to true
    let(:then_tree) { { if: { condition: t_true, then: t_true, else: t_false } } }
    # Tree evauluates to true, as `then` tree is true
    let(:tree) { { if: { condition: t_true, then: then_tree, else: t_false } } }

    it { is_expected.to eq('true') }
  end

  describe 'nested else' do
    # Tree for `else` evaluates to false
    let(:else_tree) { { if: { condition: t_false, then: t_true, else: t_false } } }
    # Tree evauluates to false, as `else` tree is true
    let(:tree) { { if: { condition: t_false, then: t_true, else: else_tree } } }

    it { is_expected.to eq('false') }
  end
end
