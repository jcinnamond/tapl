require 'spec_helper'
require 'parser'

RSpec.describe Parser do
  subject { described_class.new.parse(program) }

  let(:t_true) { { term: 'true' } }
  let(:t_false) { { term: 'false' } }

  describe 'true' do
    let(:program) { 'true' }
    it { is_expected.to eq(t_true) }
  end

  describe 'false' do
    let(:program) { 'false' }
    it { is_expected.to eq(t_false) }
  end

  describe 'if true then true else false' do
    let(:program) { 'if true then true else false' }
    let(:t_if) { { if: { condition: t_true, then: t_true, else: t_false } } }
    it { is_expected.to eq(t_if) }
  end

  describe 'complex program' do
    let(:program) do
      <<-PROG
        if true
          then if false then false else true
          else if true then false else false
      PROG
    end
    let(:t_nested_then) { { if: { condition: t_false, then: t_false, else: t_true } } }
    let(:t_nested_else) { { if: { condition: t_true, then: t_false, else: t_false } } }
    let(:t_if) { { if: { condition: t_true, then: t_nested_then, else: t_nested_else } } }
    it { is_expected.to eq(t_if) }
  end
end
