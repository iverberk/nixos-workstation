{ config, lib, pkgs, ... }:

{
  xdg.enable = true;
  xdg.configFile."i3/config".text = builtins.readFile ./home/i3;
  xdg.configFile."rofi/config.rasi".text = builtins.readFile ./home/rofi;

  xresources.extraConfig = builtins.readFile ./home/Xresources;

  #---------------------------------------------------------------------
  # Packages
  #---------------------------------------------------------------------

  # Packages I always want installed. Most packages I install using
  # per-project flakes sourced with direnv and nix-shell, so this is
  # not a huge list.
  home.packages = [
    pkgs.bat
    pkgs.fd
    pkgs.firefox
    pkgs.fzf
    pkgs.git-crypt
    pkgs.htop
    pkgs.rofi
    pkgs.jq
    pkgs.ripgrep
    pkgs.rofi
    pkgs.tree
    pkgs.watch
    pkgs.go
    pkgs.gopls
  ];

  #---------------------------------------------------------------------
  # Env vars and dotfiles
  #---------------------------------------------------------------------

  home.sessionVariables = {
    LANG = "en_US.UTF-8";
    LC_CTYPE = "en_US.UTF-8";
    LC_ALL = "en_US.UTF-8";
    EDITOR = "nvim";
    PAGER = "less -FirSwX";
    MANPAGER = "sh -c 'col -bx | ${pkgs.bat}/bin/bat -l man -p'";
  };

  home.file.".inputrc".source = ./home/inputrc;

  #---------------------------------------------------------------------
  # Programs
  #---------------------------------------------------------------------
  programs.direnv= {
    enable = true;

    config = {};
  };

  programs.i3status = {
    enable = true;

    general = {
      colors = true;
      color_good = "#8C9440";
      color_bad = "#A54242";
      color_degraded = "#DE935F";
    };

    modules = {
      ipv6.enable = false;
      "wireless _first_".enable = false;
      "battery all".enable = false;
    };
  };

  programs.fish = {
    enable = true;

    shellAliases = {
      lg = "lazygit";
      k = "kubectl";
      K = "kubectl -n kube-system";
      ka = "kubectl apply";
      Ka = "kubectl apply -n kube-system";
      kco = "kubectl config";
      kc = "kubectl create";
      kcd = "kubectl config set-context $(kubectl config current-context) --namespace ";
      Kc = "kubectl create -n kube-system";
      kcsn = "kubectl config set-context --current --namespace";
      kd = "kubectl describe";
      Kd = "kubectl describe -n kube-system";
      kdp = "kubectl describe pod";
      Kdp = "kubectl describe pod -n kube-system";
      kdd = "kubectl describe deployment";
      Kdd = "kubectl describe deployment -n kube-system";
      kdc = "kubectl describe configmaps";
      Kdc = "kubectl describe configmaps -n kube-system";
      kds = "kubectl describe services";
      Kds = "kubectl describe services -n kube-system";
      kdss = "kubectl describe statefulsets.apps";
      Kdss = "kubectl describe statefulsets.apps -n kube-system";
      kdn = "kubectl describe node";
      kg = "kubectl get";
      Kg = "kubectl get -n kube-system";
      kgp = "kubectl get pod";
      Kgp = "kubectl get pod -n kube-system";
      kgss = "kubectl get statefulsets.apps";
      Kgss = "kubectl get statefulsets.apps -n kube-system";
      kgd = "kubectl get deployment";
      Kgd = "kubectl get deployment -n kube-system";
      kgc = "kubectl get configmaps";
      Kgc = "kubectl get configmaps -n kube-system";
      kgs = "kubectl get services";
      Kgs = "kubectl get services -n kube-system";
      kgn = "kubectl get node";
      kD = "kubectl delete";
      KD = "kubectl delete -n kube-system";
      kDp = "kubectl delete pod";
      KDp = "kubectl delete pod -n kube-system";
      kDss = "kubectl delete statefulsets.apps";
      KDss = "kubectl delete statefulsets.apps -n kube-system";
      kDd = "kubectl delete deployment";
      KDd = "kubectl delete deployment -n kube-system";
      kDc = "kubectl delete configmaps";
      KDc = "kubectl delete configmaps -n kube-system";
      kDs = "kubectl delete services";
      KDs = "kubectl delete services -n kube-system";
      kDn = "kubectl delete node";
      KDn = "kubectl delete node -n kube-system";
      kr = "kubectl replace";
      ke = "kubectl explain";
      kl = "kubectl logs";
      Kl = "kubectl logs -n kube-system";
      kp = "kubectl proxy";
      kpf = "kubectl port-forward";
      kns = "kubectl config set-context $(kubectl config current-context) --namespace ";
      kro = "kubectl rollout";
      kx = "kubectl explain";

      g = "git";
      ga = "git add";
      gb = "git branch";
      gbr = "git branch";
      gc = "git commit -v --untracked-files=no";
      gcl = "git clone";
      gco = "git checkout";
      gcob = "git checkout -b";
      gcom = "git checkout master";
      gcp = "git cherry-pick";
      gd = "git diff";
      gdca = "git diff --cached";
      gf = "git fetch";
      gl = "git log";
      gm = "git merge";
      gma = "git merge --abort";
      gmff = "git fetch && git merge --ff-only";
      gp = "git push";
      gpl = "git pull";
      gplr = "git pull --rebase";
      gpo = "git push origin";
      gps = "git push";
      gpsu = "git push --set-upstream origin \$(git rev-parse --abbrev-ref HEAD)";
      gr = "git reset";
      grbm = "git rebase master";
      grc = "git rebase --continue";
      grh = "git reset --hard";
      grst = "git reset";
      gs = "git show";
      gsp = "git fetch && git rebase --autostash && git push";
      gst = "git status";
      gt = "git tag";

      # Docker
      d = "docker";
      dr = "docker run";
      di = "docker inspect";
      dim = "docker images";
      dps = "docker ps";
      de = "docker exec -it";
      dm = "docker-machine";
      drc = "docker ps | awk 'NR > 1 { print \$1 }' | xargs docker rm -f";
      drac = "docker ps -a | grep -v '.*_builder' | grep -v '.*_updater' | awk 'NR > 1 { print \$1 }' | xargs docker rm -f";
      drav = "docker volumes ls -q | xargs docker volume rm -f";
      dri = "docker images | awk 'NR > 1 { print \$3 }' | xargs docker rmi -f";
      drai = "docker images -a | awk 'NR > 1 { print \$3 }' | xargs docker rmi -f";

      rg = "rg -S --no-ignore --hidden --glob '!{.git,node_modules,**/.terraform}/**'";
      myip = "dig +short myip.opendns.com @resolver1.opendns.com";

      # Applications
      vi = "nvim";
      v = "nvim";
    };
  };

  programs.git = {
    enable = true;
    userName = "Ivo Verberk";
    userEmail = "iverberk@protonmail.com";
    aliases = {
      prettylog = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(r) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative";
      root = "rev-parse --show-toplevel";
    };
    extraConfig = {
      branch.autosetuprebase = "always";
      color.ui = true;
      core.askPass = ""; # needs to be empty to use terminal for ask pass
      credential.helper = "store"; # want to make this more secure
      github.user = "iverberk";
      push.default = "tracking";
      init.defaultBranch = "main";
    };
  };

  programs.go = {
    enable = true;
    goPath = "code/go";
  };

  programs.kitty = {
    enable = true;
    extraConfig = builtins.readFile ./home/kitty.conf;
  };

  programs.neovim = {
    enable = true;
  };

  # Make cursor not tiny on HiDPI screens
  xsession.pointerCursor = {
    name = "Vanilla-DMZ";
    package = pkgs.vanilla-dmz;
    size = 128;
  };
}
