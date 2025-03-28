# Astro Starter Kit: Basics

```sh
npm create astro@latest -- --template basics
```

[![Open in StackBlitz](https://developer.stackblitz.com/img/open_in_stackblitz.svg)](https://stackblitz.com/github/withastro/astro/tree/latest/examples/basics)
[![Open with CodeSandbox](https://assets.codesandbox.io/github/button-edit-lime.svg)](https://codesandbox.io/p/sandbox/github/withastro/astro/tree/latest/examples/basics)
[![Open in GitHub Codespaces](https://github.com/codespaces/badge.svg)](https://codespaces.new/withastro/astro?devcontainer_path=.devcontainer/basics/devcontainer.json)

> 🧑‍🚀 **Seasoned astronaut?** Delete this file. Have fun!

![just-the-basics](https://github.com/withastro/astro/assets/2244813/a0a5533c-a856-4198-8470-2d67b1d7c554)

## 🚀 Project Structure

Inside of your Astro project, you'll see the following folders and files:

```text
/
├── public/
│   └── favicon.svg
├── src/
│   ├── layouts/
│   │   └── Layout.astro
│   └── pages/
│       └── index.astro
└── package.json
```

To learn more about the folder structure of an Astro project, refer to [our guide on project structure](https://docs.astro.build/en/basics/project-structure/).

## 🧞 Commands

All commands are run from the root of the project, from a terminal:

| Command                   | Action                                           |
| :------------------------ | :----------------------------------------------- |
| `npm install`             | Installs dependencies                            |
| `npm run dev`             | Starts local dev server at `localhost:4321`      |
| `npm run build`           | Build your production site to `./dist/`          |
| `npm run preview`         | Preview your build locally, before deploying     |
| `npm run astro ...`       | Run CLI commands like `astro add`, `astro check` |
| `npm run astro -- --help` | Get help using the Astro CLI                     |

## 👀 Want to learn more?

Feel free to check [our documentation](https://docs.astro.build) or jump into our [Discord server](https://astro.build/chat).



## Saving dev.to blog entry here to also act as README


---
title: Fast Static Website Deployment
published: false
tags: devchallenge, pulumichallenge, webdev, cloud
---

*This is a submission for the [Pulumi Deploy and Document Challenge](https://dev.to/challenges/pulumi): Fast Static Website Deployment*

## What I Built
<!-- Give a quick overview of your project and what it does. -->
A static website hosted from cloudfront with contents stored in a s3 bucket all provisioned via Pulumi iac tooling/platform.
## Live Demo Link
<!-- Share a link to your project. -->
https://victorymemorialpark.codersarc.com
## Project Repo
<!-- Embed your project repo here. Be sure to include a thorough README. -->
[iac + static-site repo](https://github.com/CodersArc/vic-mem-page)

## My Journey
<!-- Document your process, including any challenges you faced, how you overcame them, and what you learned -->

This was my first time using Pulumi to do anything so it was quite a learning experience.

I first created a simple static website using Astro
Astro is one of the tools or options when it comes to create any jamstack based static-site.
Wont go into details as that probably deserves its own tutorial.
Validated everything was ok visually by running npm locally.

    npm run dev

<!--insert-local-host-snapshot-->

Now its time to setup infra in our choice of cloud provider.(AWS for this task)


<b>Very early blocker</b>

This seemed like an old bug that i could only find after running pulumi with the verbose flag.

Somehow pulumi tries to do credentials validation and that fails, so I had to set this environment variable.
    
    pulumi config set aws:skipCredentialsValidation true


<br>
<br>

Back on track after that hurdle.

<br>

I went through the steps outlined here [Get started with Pulumi & AWS](https://www.pulumi.com/docs/iac/get-started/aws/) to setup user, token and environment correctly.
Luckily pulumi has nice starter templates and cli short-cuts.
I used this one to create my starter deployment code.

    pulumi new static-website-aws-go
    
And immediately ran into a problem.
    
Oops
    
    pulumi new static-website-aws-go --dir=vic-mem-page
    error: /Users/mithuns/github/pulumi-devto-challenges/vic-mem-page is not empty; rerun in an empty directory, pass the path to an empty directory to --dir, or use --force

Ok, so we cant use the directory that we already have for static-site contents.

Time to make a decision, I think I prefer the idea to keep my iac code separate from my actual deployable.
So, I ended up create a separate folder within my site contents folder, and just providing a customized path to pulumi, letting it know where to pick my html files from.


    > cd vic-mem-page
    > mkdir deploy-iac
    > pulumi new static-website-aws-go --dir=deploy-iac
    This command will walk you through creating a new Pulumi project.

    Enter a value or leave blank to accept the (default), and press <ENTER>.
    Press ^C at any time to quit.

    Project name (deploy-iac):
    Project description (A Go program to deploy a static website on AWS):
    Created project 'deploy-iac'

    Please enter your desired stack name.
    To create a stack in an organization, use the format <org-name>/<stack-name> (e.g. `acmecorp/dev`).
    Stack name (dev): test
    Created stack 'test'

    The AWS region to deploy into (aws:region) (us-west-2):
    The file to use for error pages (errorDocument) (error.html):
    The file to use for top-level pages (indexDocument) (index.html):
    The path to the folder containing the website (path) (./www): ../../dist
    Saved config

    Installing dependencies...

    Finished installing dependencies

    Your new project is ready to go! ✨

    To perform an initial deployment, run 'cd vic-mem-page-deploy', then, run `pulumi up`

Looks like we are on the right track. Now, lets try creating this stack using pulumi cli.


    > pulumi up
    Previewing update (test)

    View in Browser (Ctrl+O): https://app.pulumi.com/mithuns/deploy-iac/test/previews/210da6e2-75a0-4cc5-9925-3a94f5b8bcc5

     Type                                    Name                 Plan
     +   pulumi:pulumi:Stack                     deploy-iac-test      create
     +   ├─ aws:s3:BucketV2                      bucket               create
     +   ├─ aws:s3:BucketOwnershipControls       ownership-controls   create
     +   ├─ aws:s3:BucketWebsiteConfigurationV2  bucket               create
     +   ├─ aws:s3:BucketPublicAccessBlock       public-access-block  create
     +   ├─ aws:cloudfront:Distribution          cdn                  create
     +   └─ synced-folder:index:S3BucketFolder   bucket-folder        create

    Outputs:
        cdnHostname   : output<string>
        cdnURL        : output<string>
        originHostname: output<string>
        originURL     : output<string>

    Resources:
        + 7 to create

    Do you want to perform this update? yes
    Updating (test)

    View in Browser (Ctrl+O): https://app.pulumi.com/mithuns/deploy-iac/test/updates/1

         Type                                    Name                 Status
         +   pulumi:pulumi:Stack                     deploy-iac-test      created (364s)
         +   ├─ aws:s3:BucketV2                      bucket               created (2s)
         +   ├─ aws:s3:BucketPublicAccessBlock       public-access-block  created (0.52s)
         +   ├─ aws:s3:BucketOwnershipControls       ownership-controls   created (1s)
         +   ├─ aws:s3:BucketWebsiteConfigurationV2  bucket               created (1s)
         +   ├─ aws:cloudfront:Distribution          cdn                  created (357s)
         +   └─ synced-folder:index:S3BucketFolder   bucket-folder        created (0.89s)

    Outputs:
        cdnHostname   : "REDACTED.cloudfront.net"
        cdnURL        : "https://REDACTED.cloudfront.net"
        originHostname: "REDACTED-us-west-2.amazonaws.com"
        originURL     : "http://REDACTED-us-west-2.amazonaws.com"

    Resources:
        + 7 created

    Duration: 6m7s



And thats it , our victory memorial park website is live at https://victorymemorialpark.codersarc.com/
Go check it out!!!






## Using Pulumi
<!-- Explain how you used Pulumi in your project and why it was beneficial. If you used Pulumi Copilot, share your key prompts with us. -->

I used pulumi to setup infra pieces.

Worked out great.

Except for a few gotchas.
1. Bucket has public access block created but not enabled or turned ON. (which is ok as per the recommended settings for s3 backed static websites but then the example here also creates cloudfront, with cloudfront you need Origin Access Control settings which are missing.)
2. Bucket policies are missing, again with cloudfront , i think we are mixing two approaches and then somehow giving an incomplete solution.
3. Cloudfront Distribution needs a public certificate through ACM.
3. A vanity url like what I am using, requires a CNAME to be specified and the cert should support that domain name.

Thats where I used Pulumi Copilot , since I am new to the pulumi go sdk, I used Copilot to update code for the above 3 requirements.

Prompts I used:- 


1. The go code generated by static-website-aws-go, there are a few gaps Public access block is created but not enabled just print code patch, not entire listing.
<!-- Don't forget to add a cover image (if you want). -->

<!-- Thanks for participating! -->