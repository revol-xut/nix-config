{ pkgs, inputs, ... }:
{
  home.file.".config/neomutt/mailcap".source = ../../dotfiles/neomutt/mailcap;

  programs = {
    mbsync.enable = true;
    msmtp.enable = true;
    #imapnotify.enable = true;
    himalaya = {
      enable = false;
      settings = { };
    };
    notmuch = {
      enable = true;
      hooks = {
        preNew = "mbsync --all";
      };
    };
  };


  accounts.email = {
    accounts = {
      dd-ix = {
        address = "tassilo@dd-ix.net";
        #gpg = {
        #  key = "91EBE87016391323642A6803B966009D57E69CC6";
        #  signByDefault = true;
        #};
        imap = {
          host = "imap.migadu.com";
          port = 993;
        };
        mbsync = {
          enable = true;
          create = "maildir";
          extraConfig = {
            account = {
              AuthMechs = "Login";
            };
            channel = { };
            local = { };
            remote = { };
          };
          subFolders = "Verbatim";
        };
        msmtp.enable = true;
        notmuch.enable = true;

        neomutt = {
          enable = true;
          extraMailboxes = [ "Sent" "Trash" ];
          mailboxName = "dd-ix";
          extraConfig = ''
            source ${../../dotfiles/neomutt/style.rc}
            set mailcap_path="~/.config/neomutt/mailcap"
            bind attach <return> view-mailcap
          '';
        };
        realName = "Tassilo Tanneberger";
        signature = {
          text = ''
            best regards
            Tassilo Tanneberger
            --------------------------------
            Professional Cable Spagetti Chef

            01062 Dresden
            E-Mail: tassilo@dd-ix.net
            --------------------------------
          '';
          showSignature = "append";
        };
        passwordCommand = "pass email/tassilo@dd-ix.net | head -1";
        smtp = {
          host = "smtp.migadu.com";
          port = 465;
        };
        userName = "tassilo@dd-ix.net";
      };
      tu-dresden = {
        address = "tassilo.tanneberger@tu-dresden.de";
        gpg = {
          key = "91EBE87016391323642A6803B966009D57E69CC6";
          signByDefault = true;
        };
        imap = {
          host = "msx.tu-dresden.de";
          port = 993;
        };
        mbsync = {
          enable = true;
          create = "maildir";
          extraConfig = {
            account = {
              AuthMechs = "Login";
            };
            channel = { };
            local = { };
            remote = { };
          };
          subFolders = "Verbatim";
        };
        msmtp.enable = true;
        notmuch.enable = true;
        neomutt = {
          enable = true;
          extraMailboxes = [ "All" "Sent" "Trash" "Drafts" "Kalender" "Notizen" "Kontakte" "Postausgang" ];
          mailboxName = "tu-dresden";
          extraConfig = ''
            source ${../../dotfiles/neomutt/style.rc}
            set mailcap_path="~/.config/neomutt/mailcap"
            bind attach <return> view-mailcap
          '';
        };
        primary = true;
        realName = "Tassilo Tanneberger";
        signature = {
          text = ''
            beste Gr????e
            Tassilo Tanneberger
            --------------------------------
            Technische Universit??t Dresden
            Fakult??t Informatik
            Chair for Compiler Construction

            01062 Dresden
            E-Mail: tassilo.tanneberger@tu-dresden.de
            --------------------------------
          '';
          showSignature = "append";
        };
        passwordCommand = "pass tu-dresden/tassilo.tanneberger@tu-dresden.de | head -1";
        smtp = {
          host = "msx.tu-dresden.de";
          port = 587;
        };
        userName = "tata551d";
      };
      # IFSR 
      ifsr = {
        address = "tassilo.tanneberger@ifsr.de";
        #gpg = {
        #  key = "91EBE87016391323642A6803B966009D57E69CC6";
        #  signByDefault = true;
        #};
        imap = {
          host = "mail.ifsr.de";
          port = 993;
        };
        mbsync = {
          enable = true;
          create = "maildir";
          extraConfig = {
            account = {
              AuthMechs = "Login";
            };
            channel = { };
            local = { };
            remote = { };
          };
          subFolders = "Verbatim";
        };
        msmtp.enable = true;
        notmuch.enable = true;

        neomutt = {
          enable = true;
          extraMailboxes = [ "Sent" "Trash" "FSR" "IT-ADMIN" "Root" "ESE" ];
          mailboxName = "ifsr";
          extraConfig = ''
            source ${../../dotfiles/neomutt/style.rc}
            set mailcap_path="~/.config/neomutt/mailcap"
            bind attach <return> view-mailcap
          '';
        };
        realName = "Tassilo Tanneberger";
        signature = {
          text = ''
            beste Gr????e
            Tassilo Tanneberger
            --------------------------------
            Sprecher des Fachschaftsrates Informatik
            der Technischen Universit??t Dresden

            01062 Dresden
            E-Mail: tassilo.tanneberger@ifsr.de
            --------------------------------
          '';
          showSignature = "append";
        };
        passwordCommand = "pass dfn/tassilo.tanneberger@ifsr.de | head -1";
        smtp = {
          host = "mail.ifsr.de";
          port = 587;
        };
        userName = "tassilo.tanneberger";
      };
    };
  };
}
