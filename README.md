# quartz-build-action

GitHub Action to build [Quartz](https://quartz.jzhao.xyz/) documentation sites directly from your content, without requiring the need to fork the main Quartz repository.

## Usage

A basic GitHub Pages deployment workflow using the `quartz-build-action` looks like this:

```yaml
name: Build Quartz Site
on:
  push:
    branches: ["main"]
permissions:
  contents: read
  pages: write
  id-token: write
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v4
      - name: Setup Pages
        uses: actions/configure-pages@v5
      - name: Build
        uses: konstfish/quartz-build-action@v3
        with:
          source: example_projects/default/content
          page_title: "Quartz"
      - name: Upload artifact
        uses: actions/upload-pages-artifact@v4
  deploy:
    runs-on: ubuntu-latest
    needs: build
    steps:
      - name: Deploy to GitHub Pages
        id: deployment
        uses: actions/deploy-pages@v4
    environment:
      name: github-pages
      url: ${{ steps.deployment.outputs.page_url }}
```

Custom configuration & layout files can be included like this:

```yaml
- name: Build
  uses: konstfish/quartz-build-action@v3
  with:
    source: example_projects/custom_theme/content
    quartz_config: example_projects/custom_theme/quartz.config.ts
    quartz_layout: example_projects/custom_theme/quartz.layout.ts
```

### Action inputs

| Input           | Default   | Description                             |
| --------------- | --------- | --------------------------------------- |
| `source`        | `./`      | The directory to build from             |
| `destination`   | `./_site` | The directory to write output into      |
| `page_title`    | `Quartz`  | Title of resulting Quartz Page          |
| `quartz_config` | ``        | Path to custom Quartz config file       |
| `quartz_layout` | ``        | Path to custom Quartz layout file       |
| `quartz_icon`   | ``        | Path to custom Quartz Page icon (png)   |
| `quartz_banner` | ``        | Path to custom Quartz Page banner (png) |
