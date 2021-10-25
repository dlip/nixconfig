final: prev: {
  myNodePackages = final.callPackage ./nodePackages { };
  skyscraper = final.callPackage ./skyscraper { };
  solang = final.callPackage ./solang { };
}
