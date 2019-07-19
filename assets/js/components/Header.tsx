import * as React from "react";

import gql from "graphql-tag";
import { useQuery } from "@apollo/react-hooks";


import { useDispatch } from "react-redux";
import { IUser } from "../models/user";
import { loginAct } from "../store/actions/auth";

import ButtonAppBar from "./ButtonAppBar";

interface IGetProfile {
  profile: {
    email: string,
    name: string,
  }
}

const GET_PROFILE = gql`
  {
    profile {
      email
      name
    }
  }
`;

const Header: React.FC = () => {
  const dispatch = useDispatch();
  const { loading, error, data } = useQuery<IGetProfile>(GET_PROFILE);
  
  if (!error && !loading && data) {
    dispatch(loginAct({
      email: data.profile.email,
      exists: true,
      firstName: data.profile.name,
      lastName: data.profile.name,
    }));
  }
  if (error && !loading) {
    dispatch(loginAct({
      exists: false,
    }));
  }

  return (
    <ButtonAppBar />
  );
};

export default Header;
