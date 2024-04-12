# AWS CodeArtifact NPM Package Template 📦

![License](https://img.shields.io/badge/license-MIT-green)

This repository serves as a template for creating and publishing private NPM packages to AWS CodeArtifact. It includes a
authorisation script essential for authorising build runners with AWS CodeArtifact, allowing seamless access and 
installation of private packages.

## Features 🌟

- 🛠 ️**Pre-install Script**: Automate AWS CodeArtifact authentication.
- 🔄 **GitHub Workflows**: Auto-release via GitHub Actions.
- 🏷️ **Semantic Release**: Automated semantic versioning.
- 📜 **TypeScript**: Strong typing with modern JavaScript.
- ✨ **Code Quality**: ESLint and Prettier integration.
- 📦 **PNPM**: Efficient package management.
- 📝 **Commitizen**: Standardized commit messages.

## Prerequisites 📋

Before you begin, ensure you have the following:
- AWS account with `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` configured. These credentials should have sufficient 
privileges to publish packages to AWS CodeArtifact.
- AWS CodeArtifact domain and repository created.
- PNPM installed globally (`npm install -g pnpm`).

## Setup 🛠️

1. Click the "Use this template" button to create a new repository from this template.
2. Clone the new repository to your local machine.
3. Install dependencies by running `pnpm install`.
4. Configure the `package.json` file with your package details.
5. Update `.releaserc.json` with your CodeArtifact domain and repository name.
6. Add repository secrets to your GitHub actions settings:
   - `AWS_ACCESS_KEY_ID`: The AWS access key ID with sufficient permissions to publish to the AWS CodeArtifact repository.
   - `AWS_SECRET_ACCESS_KEY`: The AWS secret access key corresponding to the access key ID.
7. Commit your changes and push to the master branch.

## Usage 📚

### Publishing a Package 📤

To publish a new version of your package, simply commit your changes and push to the master branch. The configured GitHub 
workflow will handle versioning and publishing to AWS CodeArtifact automatically.

### Using the Private Package 🔒

#### 1. CodeArtifact authorisation script (`codeartifact-authorise.sh`) 📄
To use the private package in another project, copy the authorisation script into your project. This script will 
authenticate your project's build process with AWS CodeArtifact, allowing it to access and install private packages.

The script requires the following environment variables to be set in your build environment:
- `AWS_ACCESS_KEY_ID`: The AWS access key ID with sufficient permissions to access the AWS CodeArtifact repository.
- `AWS_SECRET_ACCESS_KEY`: The AWS secret access key corresponding to the access key ID.
- `CODEARTIFACT_AWS_ACCOUNT`: The AWS account ID associated with the AWS CodeArtifact repository.
- `CODEARTIFACT_AWS_REGION`: The AWS region where the AWS CodeArtifact repository is located.
- `CODEARTIFACT_DOMAIN`: The AWS CodeArtifact domain where the repository is located.
- `CODEARTIFACT_REPOSITORY_NAME`: The name of the AWS CodeArtifact repository.
- `PACKAGE_SCOPE`: The scope of the private package (e.g. `@scope`).

#### 2. .npmrc File 📑
Additionally, you must add the AWS CodeArtifact repository to your project's `.npmrc` file. This file should be located 
in the root of your project and contain the following:

```
@<scope>:registry=https://<domain>-<aws-account-id>.d.codeartifact.<region>.amazonaws.com/npm/<repository>/
```

An example of the `.npmrc` file can be found next to the authorisation script, in the `resources` directory.

#### 3. Installing the Package 📦
After adding the authorisation script and `.npmrc` file, you can refer to the platform-specific instructions below to
configure your build environment to use the private package.

##### Notes ⚠️
Ideally, the `codeartifact-authorise.sh` would run automatically as part of the project's configuration (e.g. using the
`preinstall` script in the `package.json` file). However, this is not possible currently as the script modifies the
registry and the package manager does not pick up the changes until the next run.

### Platform Specific Instructions 🖥️
How you prepare a platform to use the private package will depend on the platform. All examples assume the authorisation
script is placed in a `scripts` directory at the project root. Below are instructions for some common platforms:

#### Local Development 💻
To use the private package in a local development environment, it's recommended you set the default variables in the
authorisation script. This will allow you to install the private package without setting environment variables each time.

Once configured, you can run the authorisation script before installing the package by running:
```bash
./scripts/codeartifact-authorise.sh
```

Afterwards, you can install the package using your package manager of choice as you normally would.

#### Vercel ☁️
To use the private package in a Vercel project, you must set the environment variables in the Vercel dashboard.
Additionally, you must install the AWS CLI to the Vercel build image prior to running the `install` command.

This can be done by either configuring the `install command` in the Vercel dashboard or by adding a `vercel.json` file to 
the project with the following configuration:

##### Node.js 16.x and 18.x 📦
```json
{
  "installCommand": "yum install awscli -y && aws --version && ./scripts/codeartifact-authorise.sh && npm install"
}
```

##### Node.js 20.x 📦
```json
{
  "installCommand": "dnf install awscli -y && aws --version && ./scripts/codeartifact-authorise.sh && npm install"
}
```

## License 📄

Distributed under the MIT License. See `LICENSE` for more information.
