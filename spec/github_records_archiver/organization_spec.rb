RSpec.describe GitHubRecordsArchiver::Organization do
  let(:org_name) { 'balter-test-org' }
  subject { described_class.new(org_name) }

  before do
    stub_api_request('orgs/balter-test-org')
    stub_api_request('orgs/balter-test-org/repos', per_page: 100)
    stub_api_request('orgs/balter-test-org/teams', per_page: 100)
  end

  it 'stores the name' do
    expect(subject.name).to eql(org_name)
  end

  it 'retrieves metadata' do
    expect(subject.data).to be_a(Sawyer::Resource)
    expect(subject.login).to eql(org_name)
  end

  it 'returns repos' do
    expect(subject.repositories).to be_an(Array)
    repo = subject.repositories.first
    expect(repo).to be_a(GitHubRecordsArchiver::Repository)
  end

  it 'returns teams' do
    expect(subject.teams).to be_an(Array)
    expect(subject.teams.first).to be_a(GitHubRecordsArchiver::Team)
  end

  it 'returns the archive dir' do
    path = File.expand_path "../../archive/#{org_name}", __dir__
    expect(subject.archive_dir).to eql(path)
    expect(Dir.exist?(subject.archive_dir)).to be_truthy
  end

  it 'returns the teams dir' do
    path = File.expand_path "../../archive/#{org_name}/teams", __dir__
    expect(subject.teams_dir).to eql(path)
    expect(Dir.exist?(subject.teams_dir)).to be_truthy
  end
end
