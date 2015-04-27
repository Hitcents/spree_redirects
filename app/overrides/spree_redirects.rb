Deface::Override.new(:virtual_path  => "spree/admin/shared/sub_menu/_configuration",
                     :name          => "spree_redirect_config_opt",
                     :insert_bottom => "[data-hook='admin_configurations_sidebar_menu']",
                     :partial       => "spree/admin/shared/redirect_config",
                     :disabled      => false)
