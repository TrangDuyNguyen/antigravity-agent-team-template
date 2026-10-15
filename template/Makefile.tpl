# ==============================================================================
# Makefile — Antigravity Multi-Agent Workflow Automation
# ==============================================================================

.PHONY: pipeline pipeline-status pipeline-next pipeline-reset \
        agent-all agent-tech-lead agent-po agent-ba agent-design \
        agent-dev agent-qa agent-reviewer agent-security agent-pm \
        check-files

# =======================================================
# End-to-End Quality Gate Pipeline (Relay Race Hand-off)
# =======================================================
pipeline:
	@if [ -z "$(FEATURE)" ]; then \
		echo "❌ Vui lòng cung cấp tên tính năng: make pipeline FEATURE=ten-tinh-nang"; \
	else \
		bash scripts/gate_pipeline.sh start "$(FEATURE)"; \
	fi

pipeline-status:
	@bash scripts/gate_pipeline.sh status

pipeline-next:
	@bash scripts/gate_pipeline.sh next

pipeline-reset:
	@bash scripts/gate_pipeline.sh reset

# =======================================================
# Individual Sub-Agent CLI Session Launchers
# =======================================================
agent-all:
	@bash scripts/launch_agent_session.sh all

agent-tech-lead:
	@bash scripts/launch_agent_session.sh tech-lead

agent-po:
	@bash scripts/launch_agent_session.sh po

agent-ba:
	@bash scripts/launch_agent_session.sh ba

agent-design:
	@bash scripts/launch_agent_session.sh design

agent-dev:
	@bash scripts/launch_agent_session.sh dev

agent-qa:
	@bash scripts/launch_agent_session.sh qa

agent-reviewer:
	@bash scripts/launch_agent_session.sh reviewer

agent-security:
	@bash scripts/launch_agent_session.sh security

agent-pm:
	@bash scripts/launch_agent_session.sh pm

# =======================================================
# Quality & Ponytail Discipline
# =======================================================
check-files:
	@bash scripts/check_file_length.sh
