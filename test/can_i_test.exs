defmodule CanITest do
  use ExUnit.Case
  doctest CanI

  describe "load_configs" do
    test "Simple test" do
      conf = CanI.load_configs "test/fixtures/configs/test1.json"
      assert conf["subsystems"]["components"]["level_two"] == %{}
    end
  end
  
  describe "do?" do
    setup do
      %{conf: CanI.load_configs("test/fixtures/configs/test1.json") }
    end
    
    test "should fail with empty params", %{ conf: conf } do
      assert {:error, _ } = CanI.do?(conf, "", "", "")
    end
    
    test "can do with valid role", %{ conf: conf } do
      assert {:ok, true} = CanI.do?(conf, "admin.super", "read", "build.promotion")
    end
    
    test "cannot delete", %{ conf: conf } do
      assert {:ok, false} = CanI.do?(conf, "admin.super", "delete", "build.promotion")
    end
    
    test "can change", %{ conf: conf } do
      assert {:ok, true} = CanI.do?(conf, "admin.super", "change", "build.promotion")
    end
    
    test "should have read access with global subsystem access", %{ conf: conf } do
      assert {:ok, false} = CanI.do?(conf, "admin", "read", "build.promotion")
    end
    
    test "should have change access with global subsystem access", %{ conf: conf } do
      assert {:ok, true} = CanI.do?(conf, "admin", "change", "build.promotion")
    end
    
    test "should not conflict when roles are substrings", %{ conf: conf } do
      assert {:ok, false} = CanI.do?(conf, "admin2", "change", "components")
    end
  end
  
end