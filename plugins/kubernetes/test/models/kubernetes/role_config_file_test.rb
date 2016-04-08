require_relative '../../test_helper'

describe Kubernetes::RoleConfigFile do

  describe 'Parsing a valid Kubernetes config file' do
    let(:contents) { parse_role_config_file('kubernetes_role_config_file') }

    let(:config_file) { Kubernetes::RoleConfigFile.new(contents, 'some-file.yml') }

    it 'should load a deployment with its contents' do
      config_file.deployment.wont_be_nil

      # Labels
      config_file.deployment.metadata.labels.role.must_equal 'some-role'

      # Replicas
      config_file.deployment.spec.replicas.must_equal 2

      # Selector
      config_file.deployment.spec.selector.project.must_equal 'some-project'
      config_file.deployment.spec.selector.role.must_equal 'some-role'

      # Pod Template
      config_file.deployment.spec.template.metadata.name.must_equal 'some-project-pod'
      config_file.deployment.spec.template.metadata.labels.project.must_equal 'some-project'
      config_file.deployment.spec.template.metadata.labels.role.must_equal 'some-role'

      # Container
      config_file.deployment.cpu_m.must_equal 0.5
      config_file.deployment.ram_mi.must_equal 100
    end

    it 'should load a service with its contents' do
      config_file.service.wont_be_nil

      # Service Name
      config_file.service.metadata.name.must_equal 'some-project'

      # Labels
      config_file.service.metadata.labels.project.must_equal 'some-project'

      # Selector
      config_file.service.spec.selector.project.must_equal 'some-project'
      config_file.service.spec.selector.role.must_equal 'some-role'
    end
  end

  describe 'Parsing a Kubernetes with a missing deployment' do
    let(:contents) { parse_role_config_file('kubernetes_invalid_role_config_file') }

    it 'should raise an exception' do
      assert_raises RuntimeError do
        Kubernetes::RoleConfigFile.new(contents, 'some-file.yml')
      end
    end
  end
end
