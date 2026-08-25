$env.config = {
  # ... dine andre indstillinger
  hooks: {
    display_output: {
      if ($in | describe | str contains "table") or ($in | describe | str contains "list") or ($in | describe | str contains "record") {
        $in | to nuon --indent 2  # Her tvinger vi NUON i stedet for tabel
      } else {
        table # Hvis det er noget andet, så brug standard tabel-visning
      }
    }
  }
}
