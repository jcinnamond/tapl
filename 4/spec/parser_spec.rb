require 'spec_helper'
require 'untyped'

RSpec.describe UntypedParser do
  subject { described_class.new.parse(program) }

  describe 'true' do
    let(:program) { 'true' }
    it { is_expected.to eq([{ true: 'true' }]) }
  end

  describe 'false' do
    let(:program) { 'false' }
    it { is_expected.to eq([{ false: 'false' }]) }
  end

  describe 'if true then true else false' do
    let(:program) { 'if true then true else false' }
    it do
      is_expected.to eq([{ if: { condition: { true: 'true' },
                                 then: { true: 'true' },
                                 else: { false: 'false' } } }])
    end
  end

  describe 'complex program' do
    let(:program) do
      <<-PROG
        if true
          then if false then false else true
          else if true then false else false
      PROG
    end
    let(:t_true) { { true: 'true' } }
    let(:t_false) { { false: 'false' } }
    let(:t_nested_then) { { if: { condition: t_false, then: t_false, else: t_true } } }
    let(:t_nested_else) { { if: { condition: t_true, then: t_false, else: t_false } } }
    let(:t_if) { { if: { condition: t_true, then: t_nested_then, else: t_nested_else } } }

    it do
      is_expected.to eq([t_if])
    end
  end
end
