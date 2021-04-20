local BDS_VERSION = '1.16.20.03';
local IMAGE_NAME = 'bedrock-server';

local IS_DEFAULT_BRANCH = "${DRONE_BRANCH}" == "master";
local NAMESPACE = if IS_DEFAULT_BRANCH then "fiftyonefifty" else "fiftyonefifty-dev"; # To be changed later
local FULL_IMAGE_NAME = NAMESPACE + "/" + IMAGE_NAME;
local TAGS = if IS_DEFAULT_BRANCH then [BDS_VERSION,"latest"] else [BDS_VERSION + "-${DRONE_BRANCH}.${DRONE_BUILD_NUMBER}"];
local TEST_TAG = TAGS[0] + "-test";

[{
  kind: "pipeline",
  type: "docker",
  name: "Build",

  steps: [
    {
      name: "build image",
      image: "plugins/docker",
      settings: {
        build_args: ["BDS_VERSION=" + BDS_VERSION],
        // repo: FULL_IMAGE_NAME,
        insecure: true,
        tags: TAGS
      }
    }

    // {
    //   name: "build test image",
    //   image: "plugins/docker",
    //   settings: {
    //     dockerfile: "Dockerfile.test",
    //     build_args: ["IMAGE_UNDER_TEST=" + FULL_IMAGE_NAME + ":" + TAGS[0], "GOSS_VERSION=v0.3.13"],
    //     repo: FULL_IMAGE_NAME,
    //     registry: DOCKER_REGISTRY,
    //     insecure: true,
    //     tags: [TEST_TAG]
    //   }
    // },

    // {
    //   name: "run test image",
    //   image: FULL_IMAGE_NAME + ":" + TEST_TAG
    // },

    // {
    //   name: "notify",
    //   image: "plugins/slack",
    //   settings: {
    //     username: "Drone",
    //     webhook: {
    //       from_secret: "SLACK_WEBHOOK"
    //     },
    //     template: "
    //       {{#success build.status}}
    //         {{repo.name}} ({{build.branch}} {{build.number}}) succeeded.
    //         " + FULL_IMAGE_NAME + ":" + TAGS[0] + "
    //         {{build.link}}
    //       {{else}}
    //         {{repo.name}} ({{build.branch}} {{build.number}}) failed.
    //         {{build.link}}
    //       {{/success}}"
    //   }
    // }
  ],

  trigger: {
    event: ["push", "pull_request"]
  }
}]