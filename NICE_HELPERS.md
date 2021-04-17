# Helfer zum Debuggen

## Registrieren Controller

```
@override
void initState() {
  username.text = "Bob";
  password.text = "\$Test1234";
  repeatPassword.text = "\$Test1234";
  email.text = "abcd1234@stud.hs-kl.de";
  firstname.text = "Bob";
  lastname.text = "Der";
  street.text = "Baumeister";
  streetNr.text = "1";
  zip.text = "11111";
  city.text = "Berlin";
  super.initState();
}
```

## Login Controller

```
@override
void initState() {
  username.text = "test";
  password.text = "test";
  super.initState();
}
```