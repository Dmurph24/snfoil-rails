# frozen_string_literal: true

require 'rails_helper'
require 'sn_foil/rails/controller/api'

RSpec.describe SnFoil::Rails::Controller::API do
  let(:subject) { described_class }
  let(:instance) { subject.new }
  let(:context) { double }
  let(:context_instance) { double }

  before do
    subject.context context
    allow(context).to receive(:new).and_return(context_instance)
  end

  describe '#self.serializer' do
    let(:serializer) { double }

    before { subject.serializer(serializer) }

    it 'sets i_serializer' do
      expect(subject.i_serializer).to eq serializer
    end

    it 'manipulates #serializer' do
      expect(subject.new.serializer).to eq serializer
    end
  end

  describe '#self.deserializer' do
    let(:deserializer) { double }

    before { subject.deserializer(deserializer) }

    it 'sets i_deserializer' do
      expect(subject.i_deserializer).to eq deserializer
    end

    it 'manipulates #deserializer' do
      expect(subject.new.deserializer).to eq deserializer
    end
  end

  describe '#serializer' do
    let(:serializer) { double }

    before { subject.serializer(serializer) }

    it 'uses the class var i_serializer' do
      expect(subject.new.serializer).to eq serializer
    end

    context 'with options[:serializer] => value' do
      let(:options_serializer) { double }

      it 'uses the option' do
        expect(subject.new.serializer(serializer: options_serializer)).to eq options_serializer
      end
    end
  end

  describe '#deserializer' do
    let(:deserializer) { double }

    before { subject.deserializer(deserializer) }

    it 'uses the class var i_deserializer' do
      expect(subject.new.deserializer).to eq deserializer
    end

    context 'with options[:deserializer] => value' do
      let(:options_deserializer) { double }

      it 'uses the option' do
        expect(subject.new.deserializer(deserializer: options_deserializer)).to eq options_deserializer
      end
    end
  end

  describe '#setup_options' do
    let(:options) { { params: { id: 1 } } }
    let(:output) { instance.setup_options(options) }
    let(:deserializer) { double }

    before do
      allow(deserializer).to receive(:new).and_return({})
    end

    it 'doesn\'t deserialize by default' do
      subject.deserializer deserializer
      expect(deserializer).not_to have_received(:new)
    end

    context 'with options[:deserialize] => true' do
      let(:options) { { deserialize: true, params: { id: 1 } } }

      it 'deserializes the params using the deserializer' do
        subject.deserializer deserializer
        output
        expect(deserializer).to have_received(:new).once
      end

      context 'without a deserializer configured' do
        it 'doesn\'t deserialize' do
          expect(deserializer).not_to have_received(:new)
        end
      end
    end
  end

  describe '#setup_create' do
    before do
      allow(instance).to receive(:setup_options)
      instance.setup_create
    end

    it 'calls setup_options' do
      expect(instance).to have_received(:setup_options)
    end

    it 'injects deserialize => true' do
      expect(instance).to have_received(:setup_options).with(hash_including(deserialize: true))
    end
  end

  describe '#setup_update' do
    before do
      allow(instance).to receive(:setup_options)
      instance.setup_update
    end

    it 'calls setup_options' do
      expect(instance).to have_received(:setup_options)
    end

    it 'injects deserialize => true' do
      expect(instance).to have_received(:setup_options).with(hash_including(deserialize: true))
    end
  end
end
