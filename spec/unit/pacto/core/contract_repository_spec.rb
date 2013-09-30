describe Pacto do
  let(:tag) { 'contract_tag' }
  let(:another_tag) { 'another_tag' }
  let(:contract) { double('contract') }
  let(:another_contract) { double('another_contract') }

  after do
    described_class.unregister_all!
  end

  describe '.register' do
    context 'no tag' do
      it 'should register the contract with the default tag' do
        described_class.register_contract contract
        expect(described_class.registered[:default]).to include(contract)
      end
    end

    context 'one tag' do
      it 'should register a contract under a given tag' do
        described_class.register_contract(contract, tag)
        expect(described_class.registered[tag]).to include(contract)
      end

      it 'should not duplicate a contract when it has already been registered with the same tag' do
        described_class.register_contract(contract, tag)
        described_class.register_contract(contract, tag)
        expect(described_class.registered[tag]).to include(contract)
        described_class.registered[tag].should have(1).items
      end
    end

    context 'multiple tags' do
      it 'should register a contract using different tags' do
        described_class.register_contract(contract, tag, another_tag)
        expect(described_class.registered[tag]).to include(contract)
        expect(described_class.registered[another_tag]).to include(contract)
      end

      it 'should register a tag with different contracts ' do
        described_class.register_contract(contract, tag)
        described_class.register_contract(another_contract, tag)
        expect(described_class.registered[tag]).to include(contract, another_contract)
      end

    end

    context 'with a block' do
      it 'should have a compact syntax for registering multiple contracts' do
        described_class.configure do |c|
          c.register_contract 'new_api/create_item_v2', :item, :new
          c.register_contract 'authentication', :default
          c.register_contract 'list_items_legacy', :legacy
          c.register_contract 'get_item_legacy', :legacy
        end
        expect(described_class.registered[:new]).to include('new_api/create_item_v2')
        expect(described_class.registered[:default]).to include('authentication')
        expect(described_class.registered[:legacy]).to include('list_items_legacy', 'get_item_legacy')
      end
    end
  end

  describe '.use' do
    before do
      described_class.register_contract(contract, tag)
      described_class.register_contract(another_contract, :default)
    end

    context 'when a contract has been registered' do
      let(:response_body) { double('response_body') }

      it 'should stub a contract with default values' do
        contract.should_receive(:stub_contract!)
        another_contract.should_receive(:stub_contract!)
        described_class.use(tag).should == 2
      end

      it 'should stub default contract if unused tag' do
        another_contract.should_receive(:stub_contract!)
        described_class.use(another_tag).should == 1
      end
    end

    context 'when contract has not been registered' do
      it 'should raise an argument error' do
        described_class.unregister_all!
        expect { described_class.use('unregistered') }.to raise_error ArgumentError
      end
    end
  end

  describe '.unregister_all!' do
    it 'should unregister all previously registered contracts' do
      described_class.register_contract(contract, tag)
      described_class.unregister_all!
      described_class.registered.should be_empty
    end
  end

  describe '.contract_for' do
    let(:request_signature) { double('request signature') }

    context 'when no contracts are found for a request' do
      it 'should return an empty list' do
        expect(described_class.contract_for request_signature).to be_empty
      end
    end

<<<<<<< HEAD
        described_class.configure do |c|
          my_contracts.each do |contract|
            c.register_contract contract
          end
        end
        Pacto::Contract.any_instance.stub(:stub_contract!).and_return(double('request_matcher'))
        result_bitmap = [false, true, true, false, false]
        Pacto::Contract.any_instance.stub(:matches?).and_return do
          result_bitmap.shift
        end
        Pacto.use :default

        expected_contracts = Set.new [my_contracts[1], my_contracts[2]]
=======
    context 'when contracts are found for a request' do
      let(:contracts_that_match)      { create_contracts 2, true }
      let(:contracts_that_dont_match) { create_contracts 3, false }
      let(:all_contracts)             { contracts_that_match + contracts_that_dont_match }
>>>>>>> c549be2241c8bd10e25d51d492d113b03a4c0755

      it 'should return the matching contracts' do
        register_and_use all_contracts
        expect(described_class.contract_for request_signature).to eq(contracts_that_match)
      end
    end
  end

  def create_contracts(total, matches)
    total.times.map do
      double('contract',
             :stub! => double('request matcher'),
             :matches? => matches)
    end.to_set
  end

  def register_and_use contracts
    contracts.each { |contract| described_class.register_contract contract }
    Pacto.use :default
  end
end
