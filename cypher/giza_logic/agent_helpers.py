import numpy as np
from giza.agents import AgentResult, GizaAgent

def create_agent(agent_id: int, chain: str, contracts: dict, account: str):
    agent = GizaAgent.from_id(
        contracts=contracts,
        id=agent_id,
        chain=chain,
        account=account,
    )
    return agent

def predict(agent: GizaAgent, X: np.ndarray):
    prediction = agent.predict(input_feed={"val": X}, verifiable=True, model_category="XGB", dry_run=True, job_size="M")
    return prediction

def get_pred_val(prediction: AgentResult):
    return prediction.value