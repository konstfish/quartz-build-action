# quartz-build-action

A simple GitHub Action for producing [Quartz](https://quartz.jzhao.xyz/) build artifacts

## Usage

A basic Pages deployment workflow with the `quartz-build-action` action looks like this.

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
        uses: actions/checkout@v3
      - name: Setup Pages
        uses: actions/configure-pages@v3
      - name: Build
        uses: konstfish/quartz-build-action@v1
        with:
          source: example_projects/default/content
          page_title: "Quartz"
      - name: Upload artifact
        uses: actions/upload-pages-artifact@v1
  deploy:
    runs-on: ubuntu-latest
    needs: build
    steps:
      - name: Deploy to GitHub Pages
        id: deployment
        uses: actions/deploy-pages@v2
    environment:
      name: github-pages
      url: ${{ steps.deployment.outputs.page_url }}
```

Custom configuration & layout files can be included like this

```yaml
      - name: Build
        uses: konstfish/quartz-build-action@v1
        with:
          source: example_projects/custom_theme/content
          quartz_config: example_projects/custom_theme/quartz.config.ts
          quartz_layout: example_projects/custom_theme/quartz.layout.ts
```

### Action inputs

| Input           | Default   | Description                        |
| --------------- | --------- | ---------------------------------- |
| `source`        | `./`      | The directory to build from        |
| `destination`   | `./_site` | The directory to write output into |
| `page_title`    | `Quartz`  | Title of resulting Quartz Page     |
| `quartz_config` | ``        | Custom Quartz config file          |
| `quartz_layout` | ``        | Custom Quartz layout file          |
