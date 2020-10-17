---
layout: post
title: ACDSee export Settings
category: Media
tags: [ACDSee]
summary: Экспортируем настройки полность
---

# ACDSee Settings


### Экспортируем настройки полность

```batch
REG export "HKCU\Software\ACD Systems" ACDSystems.reg
```

Частичные выгрузки
```batch
REG export "HKCU\Software\ACD Systems\ACDSee Ultimate\130\PropertiesPane\Metadata\Views" views.reg

REG export "HKCU\Software\ACD Systems\ACDSee Ultimate\130\Export" export.reg
```



### Here's a more complete list.

Many settings are saved in the registry,

Вместо `100` необходимо указывать свою версю. Для ```Ultimate 2020``` это будет ```130``` (уже заменил)

- Import-> [``HKCU\Software\ACD Systems\ACDSee Ultimate\130\``]**Importsettingpresets** (not imported from older versions)
- Label groups -> [`HKCU\Software\ACD Systems\ACDSee Ultimate\130\LabelPresets`] (copied from older versions)
- Develop -> [`HKCU\Software\ACD Systems\EditLib\Version 1.0\Develop\Presets`] (shared with all versions)
- Export (STRG-ALT-E) -> [`HKCU\Software\ACD Systems\ACDSee Ultimate\130\Export`] (not imported from older versions)
- Meta data presets -> [`HKCU\Software\ACD Systems\ACDSee Ultimate\130\BatchSetMetadata\Templates`] (copied from older versions)
- meta data Views -> [`HKCU\Software\ACD Systems\ACDSee Ultimate\130\PropertiesPane\Metadata\Views`] (not imported from older versions)
- Image basket -> [`HKCU\Software\ACD Systems\ACDSee Ultimate\130\Image Basket\files`] (not imported from older versions)
- External editors -> [`HKCU\Software\ACD Systems\ACDSee Ultimate\130\Editors`] (not imported from older versions)
- Workspaces -> [`HKCU\Software\ACD Systems\ACDSee Ultimate\130\EN`] (for Engish version, '\130\DE' for german version)

others are in the users appdata:
- saved Searches -> `%LOCALAPPDATA%\ACD Systems\SavedSearches\V30` (oder version use 'V20')
- Shortcuts -> `%APPDATA%\ACD Systems\ACDSee\Shortcuts` (version <v9 used ...\ACDSee\Favorites)
- private Folder -> `%LOCALAPPDATA%\ACD Systems\data\` (shared with older versions)
