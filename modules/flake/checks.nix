{inputs, ...}: {
  perSystem = {pkgs, ...}: {
    checks.laptop-boots = pkgs.testers.runNixOSTest {
      name = "laptop-boots";
      nodes.machine = {
        imports = with inputs.self.modules.nixos; [
          user
        ];
      };
      testScript = ''
        machine.wait_for_unit("multi-user.target")
        machine.succeed("id rebiz")
        machine.succeed("groups rebiz | grep -q wheel")
      '';
    };
  };
}
