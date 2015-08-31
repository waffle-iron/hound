module StyleGuide
  class Swift < Base
    LANGUAGE = "swift"

    def file_review(commit_file)
      file_review = FileReview.create!(
        filename: commit_file.filename,
        build: build,
      )

      Resque.enqueue(
        SwiftReviewJob,
        filename: commit_file.filename,
        commit_sha: commit_file.sha,
        pull_request_number: commit_file.pull_request_number,
        patch: commit_file.patch,
        content: commit_file.content,
        config: repo_config.raw_for(LANGUAGE),
      )

      file_review
    end

    def file_included?(_)
      true
    end
  end
end