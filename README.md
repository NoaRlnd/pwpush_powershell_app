# PWpush GUI

## tuto de lancement

- avoir au moins powershell 5.1 (idéalement installer powershell 7)
- créer un compte password pusher sur eu.pwpush.com
- générer sa clé API depuis le site
- installer les packages :

> Install-Package -Name 'MimeKit' -Source "https://www.nuget.org/api/v2" skipDependencies
> Install-Package -Name 'MailKit' -Source "https://www.nuget.org/api/v2"

- trouver le chemin de "MimeKit.dll" et "MailKit.dll", souvent dans :

> C:\Program Files\PackageManagement\NuGet\Packages\(MimeKit ou MailKit)\lib\netstandard2.0\leFichierDllQuilFaut.dll

- renseigner les infos nécessaires dans l'exe de setup (mail, clé API PWPush, chemin du dll)
