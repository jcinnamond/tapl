require 'spec_helper'
require 'parser'
require 'evaluation'

RSpec.describe Evaluation do
  let(:parser) { Parser.new }
  let(:evaluation) { Evaluation.new }

  subject { evaluation.apply(parser.parse(program)) }

  describe 'simple terms' do
    let(:program) { 'true' }
    it { is_expected.to eq('true') }
  end

  describe 'simple if true' do
    let(:program) { 'if true then false else true' }
    it { is_expected.to eq('false') }
  end

  describe 'simple if false' do
    let(:program) { 'if false then false else true' }
    it { is_expected.to eq('true') }
  end

  describe 'nested conditional' do
    let(:program) { 'if if true then false else true then false else true' }
    it { is_expected.to eq('true') }
  end

  describe 'nested then' do
    let(:program) { 'if true then if false then true else false else true' }
    it { is_expected.to eq('false') }
  end

  describe 'nested else' do
    let(:program) { 'if false then true else if true then false else true' }
    it { is_expected.to eq('false') }
  end

  describe 'nested everything' do
    let(:program) do
      <<-PROGRAM
        if if true then false else true
        then if true then false else true
        else if true then false else true
      PROGRAM
    end
    it { is_expected.to eq('false') }
  end
end
