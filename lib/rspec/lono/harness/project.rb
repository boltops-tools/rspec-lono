require "fileutils"
require "tmpdir"

class RSpec::Lono::Harness
  class Project
    include RSpec::Lono::Concerns

    def initialize(options={})
      @config     = options[:config] || "spec/fixtures/config"
      @blueprint  = options[:blueprint] || detection.blueprint # String. IE: demo
      @params     = options[:params] || "spec/fixtures/params"
      @vars       = options[:vars] || "spec/fixtures/vars"
      @folders    = options[:folders]
      @plugin     = options[:plugin]

      @root       = options[:root] || detection.root # IE: /home/user/lono-project/app/blueprints/demo
      @remove_test_folder = options[:remove_test_folder].nil? ? true : options[:remove_test_folder]
    end

    def create
      puts "Building test harness at: #{build_dir}"
      clean
      build_project
      build_config
      build_blueprint
      build_params
      build_vars
      build_folders
      puts "Test harness built."
      build_dir
    end

    # folders at any-level, including top-level can be copied with the folders option
    def build_folders
      return unless @folders

      @folders.each do |folder|
        dest = "#{build_dir}/#{folder}"
        FileUtils.mkdir_p(File.dirname(dest))
        FileUtils.cp_r(folder, dest)
      end
    end

    def build_project
      parent_dir = File.dirname(build_dir)
      FileUtils.mkdir_p(parent_dir)
      Dir.chdir(parent_dir) do
        project_name = File.basename(build_dir)
        args = [project_name, "--quiet"]
        Lono::CLI::New::Project.start(args)
      end
    end

    def build_config
      return unless File.exist?(@config)
      config_folder = "#{build_dir}/config"
      FileUtils.mkdir_p(File.dirname(config_folder))
      Dir.glob("#{@config}/*").each do |src|
        FileUtils.cp_r(src, config_folder)
      end
    end

    def build_blueprint
      return unless @blueprint
      build_type_folder("blueprints", @blueprint => @root)
    end

    def build_params
      build_inputs(:params)
    end

    def build_vars
      build_inputs(:vars)
    end

    # If a file has been supplied, then it gets copied over.
    #
    #     # File
    #     lono.build_test_harness(
    #       params: "spec/fixtures/params/demo.txt",
    #     end
    #
    #     # Results in:
    #     app/blueprints/#{@blueprint}/params/test.txt
    #
    # If a directory has been supplied, then the folder fully gets copied over.
    #
    #     # Directory
    #     lono.build_test_harness(
    #       params: {demo: "spec/fixtures/params/demo"},
    #     end
    #
    #     # Results in (whatever is in the folder):
    #     app/blueprints/#{@blueprint}/params/base.txt
    #     app/blueprints/#{@blueprint}/params/test.txt
    #
    def build_inputs(type)
      instance_var = instance_variable_get("@#{type}") # IE: @params or @vars
      inputs = [instance_var].compact.flatten
      ext = type == :params ? 'txt' : 'rb'
      inputs.each do |src|
        folder = "#{build_dir}/config/blueprints/#{@blueprint}/#{type}"
        FileUtils.rm_rf(folder) # wipe current params folder

        if File.directory?(src)
          FileUtils.mkdir_p(File.dirname(folder))
          FileUtils.cp_r(src, folder)
        elsif File.exist?(src) # if only a single file, then generate a test.txt since this runs under LONO_ENV=test
          dest = "#{folder}/#{Lono.env}.#{ext}"
          FileUtils.mkdir_p(File.dirname(dest))
          FileUtils.cp(src, dest)
        end
      end
    end

    # Inputs:
    #
    #     list:     options[:blueprints] or options[:stacks]
    #     type_dir: blueprints or stacks
    #
    # The list argument can support a Hash or String value.
    #
    # If provided a Hahs, it should be structured like so:
    #
    #    {vm: "app/blueprints/vm", network: "app/blueprints/network"}
    #
    # This allows for finer-control to specify what blueprints and stacks to build
    #
    # If provide a String, it should be a path to folder containing all blueprints or stacks.
    # This provides less fine-grain control but is easier to use and shorter.
    #
    def build_type_folder(type_dir, list)
      case list
      when Hash
        list.each do |name, src|
          dest = "#{build_dir}/app/#{type_dir}/#{name}"
          copy(src, dest)
          remove_test_folder(dest) if @remove_test_folder
        end
      when String
        dest = "#{build_dir}/app/#{type_dir}"
        FileUtils.rm_rf(dest)
        FileUtils.cp_r(list, dest)
      else
        raise "blueprints option must be a Hash or String"
      end
    end

    def remove_test_folder(dest)
      FileUtils.rm_rf("#{dest}/test")
    end

    def clean
      FileUtils.rm_rf(build_dir)
    end

    def copy(src, dest)
      FileUtils.mkdir_p(File.dirname(dest))
      FileUtils.cp_r(src, dest)
    end

    def build_dir
      "#{tmp_root}/#{@blueprint}"
    end

    def tmp_root
      self.class.tmp_root
    end

    def self.tmp_root
      "#{Lono.tmp_root}/test-harnesses"
    end
  end
end
