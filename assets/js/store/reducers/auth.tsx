import { AUTH_ACTIONS } from '../actions/auth';

const auth = (state = [], action : any) => {
    switch (action.type) {
        case AUTH_ACTIONS.LOGIN_ACT:
            return action.user;
        case AUTH_ACTIONS.LOGOUT_ACT:
            return { exists: false }
        default:
            return state
    }
};

export default auth;
