module Pacto
  module Extensions
    describe HashSubsetOf do
      describe '#subset_of?' do
        context 'when the other hash is the same' do
          it 'returns true' do
            expect(:a => 'a').to be_subset_of(:a => 'a')
          end
        end

        context 'when the other hash is a subset' do
          it 'returns true' do
            expect(:a => 'a').to be_subset_of(:a => 'a', :b => 'b')
          end
        end

        context 'when the other hash is not a subset' do
          it 'returns false' do
            expect(:a => 'a').to_not be_subset_of(:a => 'b')
          end
        end
      end

      describe '#normalize_keys' do
        it 'turns keys into downcased strings' do
          expect({:A => 'a'}.normalize_keys).to eq('a' => 'a')
          expect({:a => 'a'}.normalize_keys).to eq('a' => 'a')
          expect({'A' => 'a'}.normalize_keys).to eq('a' => 'a')
          expect({'a' => 'a'}.normalize_keys).to eq('a' => 'a')
        end
      end

      describe '#normalize_header_keys' do
        it 'matches headers to the style in the RFC documentation' do
          expect({:'user-agent' => 'a'}.normalize_header_keys).to eq('User-Agent' => 'a') # rubocop:disable SymbolName
          expect({:user_agent => 'a'}.normalize_header_keys).to eq('User-Agent' => 'a')
          expect({'User-Agent' => 'a'}.normalize_header_keys).to eq('User-Agent' => 'a')
          expect({'user-agent' => 'a'}.normalize_header_keys).to eq('User-Agent' => 'a')
          expect({'user_agent' => 'a'}.normalize_header_keys).to eq('User-Agent' => 'a')
          expect({'USER_AGENT' => 'a'}.normalize_header_keys).to eq('User-Agent' => 'a')
        end
      end
    end
  end
end
