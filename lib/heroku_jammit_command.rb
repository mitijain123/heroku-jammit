module Heroku::Command
  class Jammit < BaseWithApp

    def add
      is_root?

      display "===== Compiling assets...", false

        run "bundle exec jammit -f"

      display "===== Commiting assets...", false

        run "git add '#{package_path}' && git commit -m 'assets at #{formatted_date(Time.now)}'"

      display "===== Done..."
    end

    def delete
      is_root?

      display "===== Deleting compiled assets...", false

        run "rm -rf #{package_path}"

      display "===== Commiting deleted assets...", false

        run "git rm -rf #{package_path} && git commit -m 'delete assets at #{formatted_date(Time.now)}'"

      display "===== Done..."
    end

    private

      def package_path
        file = open(config_file_path) {|f| YAML.load(f) }
        dir = "public/" + (file["package_path"] || "assets")
      end

      def config_file_path
        File.join(Dir.getwd, 'config', 'assets.yml')
      end

      def missing_config_file?
        !File.exists? config_file_path
      end

      def is_root?
        if missing_config_file?
          display "app rails not found!, you need stay on the root of one rails app"
          exit
        end
      end

      def run(cmd)
        shell cmd
        if $?.exitstatus == 0
          display "[OK]"
        else
          display "[FAIL]"
        end
      end

      def formatted_date(date)
        date.strftime("%A %d, %Y")
      end

  end
end

